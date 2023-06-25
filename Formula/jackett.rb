class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.294.tar.gz"
  sha256 "f3d0f962d21d191b726a5271ba5236cc2d3926db925c6c56c0cb99ba28cfa8c9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "02bbcc89ad273c1dd37452776357fcd8135f493d6819cfacbfcdd72422153c76"
    sha256 cellar: :any,                 arm64_monterey: "35ac83c6e73abf94c23aa94a0121d7b0a4d8f705dd55aa4ac502f76bc295a661"
    sha256 cellar: :any,                 arm64_big_sur:  "4069d7d5f4a0e7b3c0a74f8e1a5d951eb06ab0cc8271f3ac4150f11e72004484"
    sha256 cellar: :any,                 ventura:        "612eb6c05d5dc079f0d34d3b1c0fc117d5a68dcc42df73d3d8882cf9861390e5"
    sha256 cellar: :any,                 monterey:       "4ffad0edf90005884b919f15dbfc2470bb2307d2bcafadd15aacd9b74d07dd9e"
    sha256 cellar: :any,                 big_sur:        "48cec2eeee161fc8cbdab5383735495926b5b32bea096beb79052e1d9e82c4eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453bebe76f9c9617cc57cf0b70873ca8fc2d3be8a1b70f15d91ba03d5793b476"
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