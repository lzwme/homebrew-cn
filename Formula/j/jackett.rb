class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1253.tar.gz"
  sha256 "f6cfc3895be2369065b548ed51c4f997b24b54d1991882171d2198933ceb3c52"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d11ac052fad498ba7245737fdf428744a308b8d1e15dc4c7fb3bd9e3e4691521"
    sha256 cellar: :any,                 arm64_monterey: "3e315389946216501e8d371adaa0f31fdaadf372809300e152fc9f324347907f"
    sha256 cellar: :any,                 ventura:        "cc2a325a54abf496d1fc4ebaf4de4fe952ce320ea27e0fa5f36f56cfbd247c19"
    sha256 cellar: :any,                 monterey:       "01c3620fa9e2edcaffce27b6dd5821662c8d60d116ad0efd2b6ed1aeecb13918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2315a74ad293f1aa4bf680378e128480e6c3b54c3903572034f23a63b0b2d84a"
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