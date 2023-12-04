class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1289.tar.gz"
  sha256 "e61e0091a9e0627fe350394a231830a437c1e3b6a6a4cbce7d166d7377657951"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8c9fcff65ace19c25bf35b6b87c78ee121bdb7fac0c294426e3fb3f7075aebec"
    sha256 cellar: :any,                 arm64_monterey: "1122beb9eb191ff396c856dcad36e307f015ac8e7e3fd453e45434f3846c3875"
    sha256 cellar: :any,                 ventura:        "87ad8ee2107f7f051936bbb1fb8dcd89b096449ff04785084a22a74d61286399"
    sha256 cellar: :any,                 monterey:       "e8f8b2047589074c8a2a48ce70b22314b0d83826d2f1f7b1cba9d933c444e71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b36a3b8c6bcb9f4bb9e5931d1da93803d0eed21a29060ee637147ba6da79b2c"
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