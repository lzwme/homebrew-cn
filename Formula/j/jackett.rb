class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1366.tar.gz"
  sha256 "ee4f0e9680682c547baeefa4637690dc2ea96db994a28adbb620b79e564d6607"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c38ad4277179e110b0df9dcea0ed74c38ed92b4019669ebaafd4b9c0b7b15ad7"
    sha256 cellar: :any,                 arm64_monterey: "4222ff1a1a72e7a19b43c98c53b19bbdf36877a2f55108ecf941bab85a01d901"
    sha256 cellar: :any,                 ventura:        "c309a20a1451ce60d1e1a2bcf990a8546e45740a4887fc6e2726b3a1a67c604c"
    sha256 cellar: :any,                 monterey:       "356addbb1976262aec8e00f1b846e6bb2b999035f12f74ae82776a70cf0bc1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "790e92edc028655ae0457990a2947c6e799fc1f4a2191b4ad40e47cafed746a1"
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