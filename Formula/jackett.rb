class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3604.tar.gz"
  sha256 "1d050ec6740749333616a50f5fe6def3bf43e8c61ad96b1233e80661963b2072"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00b6e4a166bc337c5d8353a094fbde0b37d9ec4061c79870dfd4f62930c6584f"
    sha256 cellar: :any,                 arm64_monterey: "184c0ff7e20b4fe194916d1e21020a1278825e5e64a9989889747adf0f3d8a40"
    sha256 cellar: :any,                 arm64_big_sur:  "6ec2c29abb823c7dbe689bb67c14d92674c11bb64d94cc0ed75d5eaade6f5fcd"
    sha256 cellar: :any,                 ventura:        "30e27de308a5e4cdacdd506a848b9e9b76139d6b0a53e4f9d934459cc585e6d5"
    sha256 cellar: :any,                 monterey:       "e4ec712fe1ac2717b66ab11fa2ec07c4b0dffc1ee7a84f20a004b23f04c5d9c6"
    sha256 cellar: :any,                 big_sur:        "0c6771ae002bf7fc69d3990bfdfd3c949718b46ad969c9eda1064f5aae60f2cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21015dcc63875094d2619d5b7aeb21219e5402ea1a881b9c1e587e42d2e3c0e2"
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