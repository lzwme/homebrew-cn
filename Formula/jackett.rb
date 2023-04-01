class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3723.tar.gz"
  sha256 "eed1fde8480c88d80d14ec71bcfe88c9c62e7f26245819b42d8807fb6bcbb550"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7ddfe4fda1e4d1c93b1423f6cad236e24d5d508e41250c96d20dc5319c136c70"
    sha256 cellar: :any,                 arm64_monterey: "c21494ffb1884d597a2de9bc339b02f7397bd11b7a59dcd7917fbc55cd657e98"
    sha256 cellar: :any,                 arm64_big_sur:  "5e8f93edd91d2f73963774cf36bdc6893f05370aeac459af2196e9eb657f3083"
    sha256 cellar: :any,                 ventura:        "8d4e04f293074d71dfd542c62d7e815c28b905049e72a5095162975354d7dc85"
    sha256 cellar: :any,                 monterey:       "1aa0d2601437c34ecdc2925b55c62db2689762e3daa028c0d42fdf74da2a4768"
    sha256 cellar: :any,                 big_sur:        "9759958310ebc34ff82e92a8e2b19699cfde8b9ecf52d5c0ac36ba77f4ef8db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a10ddd198e7185d1cef6e40fd4066c127f0b590fe6e29e71e30db5711f5cb4a"
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