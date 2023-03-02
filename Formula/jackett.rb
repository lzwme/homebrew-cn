class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3411.tar.gz"
  sha256 "09dc647b959c9f8269aef007f6d67fda26a3c6195a14dbedcd4e662cd00be6ad"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5a4e47847787b5e5e4c27c3205c35ea368ca82c6341a75e322f203d2c25cf4c"
    sha256 cellar: :any,                 arm64_monterey: "178a8f0618251c81074cb56bfe9838d5e3b4e585c62c1b5be697fce38465d99b"
    sha256 cellar: :any,                 arm64_big_sur:  "6714e1b258f5f9c94e9bbd43041a0b23a8a50d522082b1e68bca72dcd8c65e07"
    sha256 cellar: :any,                 ventura:        "cdfa29efa17c90e125ee204dfc4d6659bed2d780024026b71b46258e4da06f5e"
    sha256 cellar: :any,                 monterey:       "4931cd5b6cda7ada066a4e6a5b4b616b48159008db2460686d95846eb089cf42"
    sha256 cellar: :any,                 big_sur:        "97e4ec3d5fcb1a2b581e43a1732787eef246ad5b1e04f8e014da6dd1fac26908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab87c601fdc1253a2ff59fe05821add573fab304511ee80d85662b5da847b14"
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