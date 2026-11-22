class PiFactoryDaemon < Formula
  desc "Durable daemon for long-running autonomous coding missions (missiond)"
  homepage "https://github.com/MarvinPahling/pi-factory"
  head "https://github.com/MarvinPahling/pi-factory.git", branch: "main"

  depends_on "bun" => :build
  depends_on "node"

  def install
    libexec.install "package.json", "bun.lock", "tsconfig.json", "src"
    cd libexec do
      system "bun", "install", "--production", "--frozen-lockfile"
    end
    (bin/"missiond").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/src/daemon/main.ts" "$@"
    SH
  end

  service do
    run opt_bin/"missiond"
    # Restart only after a crash (signal). A non-zero exit means the daemon
    # refused to start (e.g. execution safety inspection required) and must
    # stay down until the operator acknowledges it by hand (design Q16).
    keep_alive crashed: true
    run_at_load true
    process_type :background
    working_dir Dir.home
    environment_variables PATH: std_service_path_env
    log_path var/"log/missiond.log"
    error_log_path var/"log/missiond.log"
  end

  def caveats
    <<~EOS
      Run the daemon as a launchd user agent (starts at login):
        brew services start pi-factory-daemon
      Or run it in the foreground:
        missiond
      Data lives in ~/.missiond (override with MISSIOND_DATA_DIR).
      Service logs: #{var}/log/missiond.log

      After an unclean shutdown the daemon refuses to start and the service
      stays down. Stop the service, inspect surviving commands and external
      effects, then start once by hand and restart the service:
        brew services stop pi-factory-daemon
        missiond --acknowledge-execution-safety   # Ctrl-C once it is clean
        brew services start pi-factory-daemon
      Never add the acknowledgment flag to the service definition.
    EOS
  end

  test do
    assert_match "missiond could not start", shell_output("#{bin}/missiond --invalid-argument 2>&1", 1)
  end
end
