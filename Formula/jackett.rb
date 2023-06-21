class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.265.tar.gz"
  sha256 "6f9c08f749a4eb9adf0810910f202c8156386fe680af665cf4be632fb186737c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dc7e6fb25f5662db3309844c73c842460ebfbb892f53e8aef3bdef6b03a60dbc"
    sha256 cellar: :any,                 arm64_monterey: "41d100a7a74726b17c1b43cfc6cb6c8e029be081746ab814a54bc8c206bfc8c4"
    sha256 cellar: :any,                 arm64_big_sur:  "b802276ca28ca6353f683f6db4f63c538c5e74061784b4b0ffea655d5e75e183"
    sha256 cellar: :any,                 ventura:        "76da497d25e66df90d4d42c7c78b55e5bce5fc562ccf1764a8a2809449c3420e"
    sha256 cellar: :any,                 monterey:       "d43937cba9c2ec3883fd32504da92f3d2e4367214bc325d9348e1bf3564d02a3"
    sha256 cellar: :any,                 big_sur:        "16bdd87d405a721560e84b797738388e9626f3ea0c1809f07f29157b67dfcefd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2685b31963609b9c89c53ac2c2cc8bf02f8a2935dd474209e799066915655e2"
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