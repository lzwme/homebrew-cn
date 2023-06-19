class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.245.tar.gz"
  sha256 "6f0b396797729aacabb5c5350e681e2832bfcdb1abafc1d7883e0caf04b50d3b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d8d83522bbdfa3e16e51978d930c5e628adceb9949c2a47cc34533c80af7c98f"
    sha256 cellar: :any,                 arm64_monterey: "045631b0659df8e69d406274d92f76e4232efee613a7c2891c1fe6e21d904712"
    sha256 cellar: :any,                 arm64_big_sur:  "7c3122adbc07d8c4f2792d2bfe412b706cf780971219e0be64d35db2921dfc75"
    sha256 cellar: :any,                 ventura:        "83d13864adcd6caff6a03f4a085f326bae4716966a7591066f798599b75d4af6"
    sha256 cellar: :any,                 monterey:       "cfe7087084e4f6d1a98d885b9928d3a91265ac9f7b5e5d6db94a1ed2360ddac0"
    sha256 cellar: :any,                 big_sur:        "4e6b1ce66d0f410ab86bd942277028584916a7670b653c1e9a5fd67672617e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a5c07d4dd02b45d4725b301911515bd77e223847c3800aaf2e2a4a52fb19c6b"
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