class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.786.tar.gz"
  sha256 "dc8c8b60032f3f5a690f1608bb12b8a943b654fa54e2822a2619a3820d4aa5c6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b17519c26f687627e59025466ba6a1e0415d7335aa48a7e6adc1084739676155"
    sha256 cellar: :any,                 arm64_monterey: "c0e7f6b40f3f8950c87d1482f684632a1f37dadb90f372b6c092de4b064ce004"
    sha256 cellar: :any,                 arm64_big_sur:  "7998fdb314b1690cfd0737c4e7faef3678712029cc27398bcaa88ac8eee2446c"
    sha256 cellar: :any,                 ventura:        "75c615efca618999c248edca84f98ba1003b14d35ad10f634c43c63ba1c0e10d"
    sha256 cellar: :any,                 monterey:       "4e00a66d6bab92b13b1432d0784736f14a6a10531a0fb47a70694430fec212fc"
    sha256 cellar: :any,                 big_sur:        "3793b892b1b07d88bdad70afabca416046628eab502bc5d27cd6262ee9e6c209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b7e80948bc82c25974f421a94571fe45301554a16b0bfb1f588b43005bd0c94"
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