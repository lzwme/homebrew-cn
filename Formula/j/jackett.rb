class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1259.tar.gz"
  sha256 "e4c55b0841a11a54386cf4af3a445e08e44ae0fb411354e51cb069b2b8620230"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6dd0fb4b2f6cee57e299a3aa0fdfcfe1d847ade2810c43d10712526baae74513"
    sha256 cellar: :any,                 arm64_monterey: "15b5ca88c5841947fffd0bb79b1211c5648888195d93a35792ec95f5a38554c6"
    sha256 cellar: :any,                 ventura:        "1b850c0355a776bec7228221529ed44199c7d259409ce5d362734d9e5cc8ebd4"
    sha256 cellar: :any,                 monterey:       "6d3940b371bb6ca19bf4ad3f3e2fccb4bc5d6d2973d0b945147e6c6ed5f23cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be85494ec670773a414323d2399d764b0a4408be247afe21e93277114f445655"
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