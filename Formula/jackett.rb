class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3684.tar.gz"
  sha256 "9542c9a4fa73c06a3e25a62e7a45136c6fdef04ae3c8df9f7a35039b1eaf74d3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c39d1ad1ec75e41ce81aeb88c860e6ed9b09b70f25618c7ce8547ad6046ef710"
    sha256 cellar: :any,                 arm64_monterey: "c1ae96a96b54a9aa9c57e8b2f8539c9c946b3a362f13a9dede4245f588585666"
    sha256 cellar: :any,                 arm64_big_sur:  "60831eefe42312d1352bfda97ca2b3e3491fa2f593ec72f111a4a5f3d7aa2ca6"
    sha256 cellar: :any,                 ventura:        "790d8115e2f0eac5bfd728ef1ea9257abada5c7fd9cf203367fc44b03f435a99"
    sha256 cellar: :any,                 monterey:       "0e8473955a0361e5c30c40da9b3b7ca578365a656a1e02f996155dae93cd04b4"
    sha256 cellar: :any,                 big_sur:        "a894432327082ad5c041284e26eebe004c25b1f3454af3677ca7780d5765a63e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be5d9a72aeba718ccba076659499e0856d63402b604ba664c0d5c07ad1177e21"
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