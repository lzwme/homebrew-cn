class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.186.tar.gz"
  sha256 "85850c0f85aa36d3a515d241c6bb6d22c82ceeb61ccda1555025bf328da7f775"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f615843cb1ebe17655e95067dd994c6dc2b063126e36d3e97840b1e1bda47457"
    sha256 cellar: :any,                 arm64_monterey: "22f992e83d7df3bc2e858518e6238ec7eae85ac8d45e49c468c307acdd46d5c4"
    sha256 cellar: :any,                 arm64_big_sur:  "28e4faab787b39a2b949af23973f68d177ea2b0c6e34ae647045a8322e6466de"
    sha256 cellar: :any,                 ventura:        "c9144216f96d51db7eb7681523bd01d2d70f5c75b051e8a4a8b1c2cd8a7a120f"
    sha256 cellar: :any,                 monterey:       "0d317fa9a7dec954fac78a219dd49486fcd29d55c6a2a07838361c1ef1d9f025"
    sha256 cellar: :any,                 big_sur:        "64bb5b5787e7bb076b3cfcbd00a405d8833357b4bc3db078c680e24d9a7f934a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "728c8ab74049e22a509af0e8ff679cffe782fef28410e36a5056239390f4f0c6"
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