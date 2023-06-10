class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.185.tar.gz"
  sha256 "90569789319d94565db9429f1b70906a6a0d98bed100f9ba0be177cd2d24c1f6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98acef1b2c85e8df10f79e7f89e75eea6ce94690c2a8c82842cb648ac964c9d3"
    sha256 cellar: :any,                 arm64_monterey: "e0a618d472530ec7180e7a45b4bc1820375c2594faea23c6220c2aa309959d71"
    sha256 cellar: :any,                 arm64_big_sur:  "466579cbaa75637da780c30840dacac3261113498e38ce1a962d85cc4645d38a"
    sha256 cellar: :any,                 ventura:        "a311817117033b244e2eec07e5c37aaaac4823e0aa1895d03ca9c7d911f522fc"
    sha256 cellar: :any,                 monterey:       "e7958ee5db02e3161b87ce35bf3a83c4c6feeaf85519f06f07805f1720aa36e1"
    sha256 cellar: :any,                 big_sur:        "e6faae6365ca290ecc6e92ebd7279fbb05c7fe5afe6bbbd045ff33db4137a53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a36aae6f93e6539678cadd7195355b259dacbd3bd3f4f0c5676ef535f44de31"
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