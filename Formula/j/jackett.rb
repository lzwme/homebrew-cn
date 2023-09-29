class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.919.tar.gz"
  sha256 "bde09c3c722338f4b6fc3437f36427c4c1ca22b7f3112e8e9e6a921e9963ab2e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1839aaa5d8c8257165df162314efa3a76492a41fce96ae0e6392077cf11aefdd"
    sha256 cellar: :any,                 arm64_monterey: "a7cc4fd0377f1df632a5592ddd2db4cc2a4e1620d0627352cfcfaa2305756038"
    sha256 cellar: :any,                 ventura:        "fa7c71224f54f08a8be1fe2ffaadc79dd6c4adf91946a30072436b8c0be7aac6"
    sha256 cellar: :any,                 monterey:       "6aa93653eab3e663342d14fe004eb644e89fb51d439a030f480bf7bd66e368c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e0f1b617d1390ab5c4de9ab8c03e9fcdeaab3c1f6e578df93038a154a47c202"
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