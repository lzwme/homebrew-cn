class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3664.tar.gz"
  sha256 "1da90d0506f96671492aef078890d92f8246553a80958a30878fa689db987385"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7273f377fac92b7a701ae940871f60d23d04dd21afd946f4ba6865f57c95516b"
    sha256 cellar: :any,                 arm64_monterey: "fec86f3c87d63ecd99f579e3bf5c3e26375af5211746c85d169d563206393b0f"
    sha256 cellar: :any,                 arm64_big_sur:  "20e99062968fcadee87493e5517c38170d41175a2811be64d4311410ecfbc744"
    sha256 cellar: :any,                 ventura:        "16f57fdfe6b9dd97ad7fbbae5337783acc1577d256109578ee1689167afcf86e"
    sha256 cellar: :any,                 monterey:       "2e1fb113ac897a1ce191071a88aa5e4ae4fd58c0dfab2f21ff585510349f7be6"
    sha256 cellar: :any,                 big_sur:        "97f794f8134c8bbf9bf02695ca643da71c4fe163d155c85cd544dde76fec80e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34e5d69ab3b68685ad5c7239d9ced8e471ae1ab8e63dbdf17e33611728983106"
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