class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4013.tar.gz"
  sha256 "56b573c3032b1eaab8b9c6adb37fdc94b9c7597e687b2c648dd9da71a35f73fa"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3bc323232ea5aec38b314738bff974f728db132e13ee06e689052617959d5b37"
    sha256 cellar: :any,                 arm64_monterey: "cbee81e81da14a3b7f8027fe83a324ea51d363b3e8e74d0aa776c4546596098c"
    sha256 cellar: :any,                 arm64_big_sur:  "0a3401063dd4ca9ff4b167a34c2316efa7932c30c00772012ffb043c58eb2933"
    sha256 cellar: :any,                 ventura:        "12aed8e099d707e70b1e8709446226b468056baaab21b305008b37a6d2eb6068"
    sha256 cellar: :any,                 monterey:       "ccfd36faed29155e9f7c6dd2d1e0309beb3649ad29afb385b3510b0c699e9adb"
    sha256 cellar: :any,                 big_sur:        "79ff2cd7d5f39c4d334a2936cbd9b22ba0c2bdbe09a92576928f00d0b66d9f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a7a561c5de49405232f29142fe9817eb85707031c799d5ced4b1a050e98743c"
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
    working_dir libexec
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