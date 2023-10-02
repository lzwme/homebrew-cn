class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.946.tar.gz"
  sha256 "c9f43133b79ede84378037848af27f5986d9c7ae3415ce903b5e4a52ed344147"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dba94f31631a9c3277b7caa6116e8081e56d3ee7551ae9acbd85bc775b8b3520"
    sha256 cellar: :any,                 arm64_monterey: "3642b2eb5d2f8f0d94e420f99407f24ed9bdf2f4a02a2b0497a37f89757ccd70"
    sha256 cellar: :any,                 ventura:        "60fb35d66ab7c1f2c43cc086ff52a51bb84e30275aef2f5068c9a68491aa9019"
    sha256 cellar: :any,                 monterey:       "2e357f4d603849d894aa849cd258f93cc102e5f9f9c2f2269bb6947a61eb1777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "065a841f365715a27e578765e7a7c56c6a801d119970cd65859509d08e28ce58"
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