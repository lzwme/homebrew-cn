class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.449.tar.gz"
  sha256 "7d609bb0511d14b99de5f77458794ba335b8971ec8dd371304271d8cac3199c6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "29795a6303c151849bc8509d2985b8e3b8966e7e0e60ef0ed2ca739f27b42066"
    sha256 cellar: :any,                 arm64_monterey: "24fa1261837d9dde40af63d9f3f5b49bb6ceb13789ef91cd2a7af246039d8b80"
    sha256 cellar: :any,                 arm64_big_sur:  "4ca63a403d244c0a4ca980434fdc0d57ded09f4458934998a3ba66ac91b0ec69"
    sha256 cellar: :any,                 ventura:        "032c1b8907702412f3638cf0fa2374f0935e459583d9f7eb5499a01ff6a1b239"
    sha256 cellar: :any,                 monterey:       "79c622195d16f9d8f163ca2422e5a14ab77f7c9209aa72a16dc22139d434a5ef"
    sha256 cellar: :any,                 big_sur:        "b315d3f888f83b385a6d15d758b9ab19fc75c708e440942a3c19ee99092e18b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f523c43305f79bdb8f3227ba21e760ab8032e60596e44d9381753e953f768dc9"
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