class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3366.tar.gz"
  sha256 "d4487a4adff57ea7b2d792232297cbd998e5588a988c1ed1a7e981914f5b32d2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "be1d1c425fc933593f7f3aa93a2bbc8130af0891f2c2b3cd513d4373bf3cffdd"
    sha256 cellar: :any,                 arm64_monterey: "ffb82481f9d100fa97b16c1e8448627474ad151ba2e4c5ba853a14f0782ca320"
    sha256 cellar: :any,                 arm64_big_sur:  "90671e2e4741577e259c64923b7406b22976db1999426ad6ae396ca411a323f8"
    sha256 cellar: :any,                 ventura:        "412af4b45e2657b39ffac885e0c9ad973cff72d20facc42758cf75b9d771a859"
    sha256 cellar: :any,                 monterey:       "096e7033321167c07ab88ee8f6e7fcb66039107416e0f734826d8410b8b93d9e"
    sha256 cellar: :any,                 big_sur:        "edbd83ce31280a9327584ab1c9e9df517a0d10f10811a7403899547174102a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b966f72e651d79753c7397436a52efa39a1f1753ad1290352277804575558e2"
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