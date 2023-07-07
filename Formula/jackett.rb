class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.418.tar.gz"
  sha256 "ccdd6e0cfa478429fa3cfda152ded5a5f91958ea8781b132d0eb416e5ca16d13"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f762b608b7b2ef45a5e31d3e767ad12d7efbc0b639d8a1c8662ce1b6b57f4b9"
    sha256 cellar: :any,                 arm64_monterey: "44914fd53837c0a8291a9b54b8a9fd07bcc1f93490ae0a88f9fd72028493a8d6"
    sha256 cellar: :any,                 arm64_big_sur:  "e7a44a15fb4df7ea9a753114a402fa6ce6fd84b6f5baceecda0f6980d8e14c74"
    sha256 cellar: :any,                 ventura:        "dc39b07aa84e7a3b386765d90dae2bb77af1d4aea161df5607d4daa3a115404a"
    sha256 cellar: :any,                 monterey:       "61fdbbdbd511581f079c85c6c2d43f6466b2142828c11403168bd420dac1dfba"
    sha256 cellar: :any,                 big_sur:        "7842d66470e1c7ade056ee400f968dfbcd91e911127b387c3666d01495673b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6254edbf1e6a5320927256337dfe6c6b027e6a7c95d80198a235e26372bc7f5f"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end