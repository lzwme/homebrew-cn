class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.947.tar.gz"
  sha256 "f8b07a776da622fdebb901299f4ad0d738dfc8857599e3df22fc0b50f0d2f38d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e13eb938cccd4f49397430e5bf27f53af47637976fa052555d25a4f0ec7315b"
    sha256 cellar: :any,                 arm64_monterey: "3ec24079121bdc8ba981eae10348f9c84f4a6a30789a74d4e1e180ab4228682e"
    sha256 cellar: :any,                 ventura:        "0a1181caf750484c45af920a340512f0189a0a81e84128c8d09885857889e5d0"
    sha256 cellar: :any,                 monterey:       "13ba43eabadb88b6e5d1ab47c72c68d5e1f903c2b8eddf663b9815ec69e7c7f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d1c269ee9b58e416217d81080f660e0ba788f8eec7b5654c335f05eb769704"
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