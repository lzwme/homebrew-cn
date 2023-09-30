class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.938.tar.gz"
  sha256 "e3d311e939d71403a69a314179af274d622d66aae0902c585af4db1fdee27d37"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c203fa325e31c206d6b74907aeaed31cdfdc12886cf7ad470e795a0ffe9d58c"
    sha256 cellar: :any,                 arm64_monterey: "aa12667f51725beec6d6de05da2db64931cc4ffa6a30cf211fb1da66d2b9b3eb"
    sha256 cellar: :any,                 ventura:        "cd2c5c40607a4728903374d7fc4ff6caaf4b1f5153f612547b4893f5c116b8ab"
    sha256 cellar: :any,                 monterey:       "896c420408ebfb429b5c775893e91ff4c233e5336acbd524dd583d8cc2211f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4dad5493aefaa01f9c8ecbb5b3eba6b240591ccfd7a326e0dae8ba0275a6b32"
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