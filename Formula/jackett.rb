class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.481.tar.gz"
  sha256 "5d3fa79b59168b2d06062845502279d7aeb2934343148d5940e2d0144162dc16"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ff2f6b7722fa55c5698443c52b8ce9b104ee4a6b9d0aa7edfc545ebcb34536a3"
    sha256 cellar: :any,                 arm64_monterey: "cfb72ee93b50d1e46a656310dfb884898f6fe5a4afc67aa0e4b676f0bd93ad22"
    sha256 cellar: :any,                 arm64_big_sur:  "3937ed0be7b7eba622225fb87113ac3c9bbf74575095e5406ac5959f2c0d067b"
    sha256 cellar: :any,                 ventura:        "5f8902cb47b50937ee1c619606723d97e379bfbb91b415a0b33fcd6f140f5abc"
    sha256 cellar: :any,                 monterey:       "2b9bf1bcc1d263332b94231eef0f066dccfaf4c16a77402338398cabf6af4a1d"
    sha256 cellar: :any,                 big_sur:        "5b96423fbe7002f98d1f222672272a13cad8b86990c0ff9e9fe5e88e484ebcae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd69362fa62da34a22f0ccd003fa5e54f9aa930649222b8fd36d90c8b8231401"
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