class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3689.tar.gz"
  sha256 "806b62beb70a565d4bdd1108334c93c565de08662078037d6ee8955cc99cb560"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "80500a3550a6b8460ff14e9a4ae8bd4b3446fee1cfc187ce11e5e404e2fb3ff2"
    sha256 cellar: :any,                 arm64_monterey: "3f9903ee750f63adad12608f957911729a7410a28e0b091f19bd87d993dd41f4"
    sha256 cellar: :any,                 arm64_big_sur:  "669b79b0443f7d8de6bfff8e22def01a3739b464df572a077863fbd4efe8b326"
    sha256 cellar: :any,                 ventura:        "08d6b4038db732984b8aeed79be916506ed8d72bef1b9ed18e96ece877593cb7"
    sha256 cellar: :any,                 monterey:       "3141cab66700eedc7dcb28047a1b46825b5ea909663c68b07aea919b7ded20b8"
    sha256 cellar: :any,                 big_sur:        "f816ff51d89ece8ae3f803d6091026af7d9259503aa6a3d301f6631ecc7fe5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aeca636ed62418914a9caa83dbf247041453bce2b165769b7f78f64f03c5a5c"
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