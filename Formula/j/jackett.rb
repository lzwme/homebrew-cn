class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.826.tar.gz"
  sha256 "91fb8a73028b8bd2a50d7fd3b91c797167345a9e1765f9d97c1057229ccaa8d4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aa934e105c5c5e841d861c8a6f7d513ce3ae49647e990db6c710fa542dcbbd11"
    sha256 cellar: :any,                 arm64_monterey: "b69f79513f94f0fcadbf0747fd46bf5775af4916f45036ba572f098b2f52e822"
    sha256 cellar: :any,                 arm64_big_sur:  "a78a616e730a7dadfa0fc04f145c162dc496c48ad2b2549a97de55e0ad7fbada"
    sha256 cellar: :any,                 ventura:        "1f97dca53731c37ed9be85f48a4060cc731d1395dafd26c459f0aabef776b506"
    sha256 cellar: :any,                 monterey:       "de03bc861f591f5966886e630d16e590ce5ad63d8cd7b2d7a45f20a5e7335d93"
    sha256 cellar: :any,                 big_sur:        "a49b9e23acdcdf2a0bc57466431cea386ee9bd01c8fec388c01579aa9b52aa4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7139e743ca8a31aceab45f49d56c33a39a9a9693acda317366345dbd714f85"
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