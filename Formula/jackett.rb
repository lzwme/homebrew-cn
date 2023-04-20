class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3939.tar.gz"
  sha256 "047b31e3efadf70856758aee54903a6a93b4fabea8fca306a34b7129895f535e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c1f6ba3b6e04c5c85f6e8a89b5d280b4042a0700469d1a117abb92a23731790"
    sha256 cellar: :any,                 arm64_monterey: "20af398ae1cd1a66532bf914c3fc260335fc0bae0e89800bdeb4f3ba23f1c203"
    sha256 cellar: :any,                 arm64_big_sur:  "5bf5650e6e00fbb6193d374925dfb0440b1fd543074ee40b3d959349cb462c38"
    sha256 cellar: :any,                 ventura:        "8295ef4565347435e61238dac9d18d8bb81e8441a4acaa9d390ea4c4bf2ca26c"
    sha256 cellar: :any,                 monterey:       "edec92ed8d4cf80be2805bdf189c08e9edb26923a28e4e5487f28038a437b88c"
    sha256 cellar: :any,                 big_sur:        "2b6c74571be534360b158cd4c1ebf6a3223d240bf1be2c7422ff4a6dfc9a9c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7845b775e6325b5218cfb3f723aac69ec42a2df90eb25f8f0ada41250f4ae014"
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