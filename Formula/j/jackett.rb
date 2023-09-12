class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.770.tar.gz"
  sha256 "d7ee59cf1bc8451787a4a28be7734ff955c366ade51a1fa72dd45f4d65fac824"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "704adb3145f4fda3f09053cc5efaf59fc0941fa0b1407eb4cfe948df11c78c9d"
    sha256 cellar: :any,                 arm64_monterey: "a9f8416fe395f77661d7dcc19b4bd96d3d8e429b026ea19de306b1d3a7930ce6"
    sha256 cellar: :any,                 arm64_big_sur:  "0e869428ac3427c1e845916d6e10682b72fb7e4fa338e29bdb9a0eb205435105"
    sha256 cellar: :any,                 ventura:        "159785508ffe4fa6f6bf1206550491fd531e17210d424445482b895831f265ce"
    sha256 cellar: :any,                 monterey:       "020deba782d8f1d3bfac875923261a5c440687b435d5a6ae6cc712b23da719a1"
    sha256 cellar: :any,                 big_sur:        "1df031f471721d260665d74f3ba7c96f45b2ba81d31b793e605980efb390b924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "195b9c6700342ee7989c671d9bd89fbfa7cc9a116264f91f7a462d73500f6f87"
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