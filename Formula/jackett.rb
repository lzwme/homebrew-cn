class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3870.tar.gz"
  sha256 "1f3c724d9af4e73c202c43f14cc7a64aae6122fe8ab67de7795fc7828b76dea9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd547b730686b6af83dd0fbb06add42ed84666685d61bd91e0cda1f926efbb47"
    sha256 cellar: :any,                 arm64_monterey: "330a152e49c2156f6eb8b656f35015654f1f8a7030957872ec6e09989997d1e9"
    sha256 cellar: :any,                 arm64_big_sur:  "62214498c0f9de756e7c083e70cde5f64128be71a4bdcaff1d1a5158caf34dd2"
    sha256 cellar: :any,                 ventura:        "d527263e3d757d64500ae97784821bab434123347c62969433864e9458f8a215"
    sha256 cellar: :any,                 monterey:       "51594dcc5937dfc0d5e380dca740cd873de89daf17b4be8932f3ce1871531b73"
    sha256 cellar: :any,                 big_sur:        "a1e34b43423b4f29e337681dec140094fe03c86c48cb13821f9021e5c691bfd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3ff47112c4e5ba1526ab8846736e29e214391a7e5c6227556ddd55e976f92a6"
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