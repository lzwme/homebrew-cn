class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.768.tar.gz"
  sha256 "181f882e2d6c8eaf8c05223a47e2c0f7dfeba2737854922008ca0e56a64233ec"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fbc406c6511e45e2e6f271aea1e94d5051d5e112c30d9cbb02a1f089303f55e1"
    sha256 cellar: :any,                 arm64_monterey: "a6a12b17e095a06dec5e82d19ee9b6433873bb763de353d9ceb82d9e3ce80feb"
    sha256 cellar: :any,                 arm64_big_sur:  "44bc6c597817edf19d09c3e09fab5fd68386744114be70ce025abf8b28238f1d"
    sha256 cellar: :any,                 ventura:        "d79e666b4d17883fc0ac897d38e53c84929b7c281c8ad6baa72c93b31822337b"
    sha256 cellar: :any,                 monterey:       "5e1c6f4a3580f6819ffe6fad58e40b202547926d42a4ed83f03d65bbce45d4d3"
    sha256 cellar: :any,                 big_sur:        "c56c4f9e2af1839e985c40613116865f74d3ba157743326d3c40610e1c7f9dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bf248bc5f0f0cecef597fbc33d2e553f5ab206deb658aa2de040e2e8273460e"
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