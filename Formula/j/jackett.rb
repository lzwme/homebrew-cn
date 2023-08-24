class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.687.tar.gz"
  sha256 "8c58602383f61824a8d6ab5d212e1c3f3c0573b402ec3a33b75be1b9b5ade9ba"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a73612b1e95e3dc1af2141d68e0f2ec08f6e301f710563ec6b420b5ef8e35b7f"
    sha256 cellar: :any,                 arm64_monterey: "f8f089760d2d0979f383dcb9b97f39768f84623f733ccf6fe17a985b6329eaeb"
    sha256 cellar: :any,                 arm64_big_sur:  "1f907f4661ae14b3389f422020bdb3c3ff895e425667b03ed83320a406e5d9ce"
    sha256 cellar: :any,                 ventura:        "9671f3f57acbe84adcdc4c26aa6f74edf7e34d8623fec257ecc888af924971de"
    sha256 cellar: :any,                 monterey:       "df564aea32b778433e5961458172cf58d96082dac26ad5b11f296405930885e2"
    sha256 cellar: :any,                 big_sur:        "3cccf386d030855318d88f2bea141ca58c10757c18c7adf49f1156de0b910157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92213f23e6ad8b7b28c3c047774447e3c00c3ac8ebcaffb0db6d3b261654c615"
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