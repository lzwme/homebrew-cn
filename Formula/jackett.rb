class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.334.tar.gz"
  sha256 "ab6ff50b84ab71b4c8149eed5fead9c3032d0dbc33d72ed30304d83f3e4f72ee"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "687492b87502eae8544727bd46b1f66e8ffb0a12334167075c16ba309f493801"
    sha256 cellar: :any,                 arm64_monterey: "08a23b76983b20faa16fa35d027329fdc53ff93bc6630c9e278ed773ee838ffb"
    sha256 cellar: :any,                 arm64_big_sur:  "dca29e69c680d8266711fdfd6705dd9adf2a74d868fec4c85faba95b9ca11c44"
    sha256 cellar: :any,                 ventura:        "57094f89ab7fa57643e7800b81f278900d862d339edfe5c38af95272f6332614"
    sha256 cellar: :any,                 monterey:       "b5c62f52c5c96c25c2da60b19e17f42162c71f180d843124f25778734d6bb1b2"
    sha256 cellar: :any,                 big_sur:        "b1bd8c45a491b8be521092a1b9d6e4c9341f0d7f85de75ddc022e6d794d71f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf5cad34fd01828e00249581f4e2e9f224b369d14bddbeb45abdd98a59c2fcc"
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