class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.378.tar.gz"
  sha256 "44ee646c3e3b1451732a9d4bc3e5b8a9d588209276312c68c37096fc6a9be0aa"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4cbbcea08c102d98ee1201b1c88be8e8cf799640df8277e7f3067ca778a0e9e3"
    sha256 cellar: :any,                 arm64_monterey: "c855e1a764741b2bbc5af125db4bc7f7f86544f8a1a1f8988760ffbf3d8939fa"
    sha256 cellar: :any,                 arm64_big_sur:  "9c6a51e7fdd387c59e69f8f450acff5ec3b56f069bce67153a11ce614349116e"
    sha256 cellar: :any,                 ventura:        "ce5e3b1d38351e21fc06c14057ffbe352aa961f72f25a390e9c6589a657ccf55"
    sha256 cellar: :any,                 monterey:       "0a00f5be6b5d78298277fcf45cf09c3627004e922ced1f9f2a60e258ad53ab08"
    sha256 cellar: :any,                 big_sur:        "d20068772109a9b2eb4f634457c1b3a002526ac5da5105edaa74940546ffede8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e27a02321df9c44ac87e7df32f51129a72d9ac48042e520c32e80273b61f6315"
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