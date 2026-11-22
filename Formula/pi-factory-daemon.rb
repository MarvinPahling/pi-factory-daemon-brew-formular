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

  def caveats
    <<~EOS
      Start the daemon in a separate terminal:
        missiond
      Data lives in ~/.missiond (override with MISSIOND_DATA_DIR).
      After an unclean shutdown, inspect running work, then start once with:
        missiond --acknowledge-execution-safety
    EOS
  end

  test do
    assert_match "missiond could not start", shell_output("#{bin}/missiond --invalid-argument 2>&1", 1)
  end
end
