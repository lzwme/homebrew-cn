class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.266.tar.gz"
  sha256 "703bf877f737be99ef43ebb7a01b5f5b9be85634568fe64255ef6ec77da447ad"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d67b809d411c1a3e0fb6f2b2281ba596b3e2a95eb58464bd443d8f19b3330ad6"
    sha256 cellar: :any,                 arm64_monterey: "1595b35bba669e1b949a2cebcfca63d17820d6f122be60b96bd877ac5da1e794"
    sha256 cellar: :any,                 arm64_big_sur:  "26719f86eb9b73ac0a26262a3dfdf2a958a418b9f4d92685c68a0f26ea48499f"
    sha256 cellar: :any,                 ventura:        "97be6ac79b66d79274cd6a2d95a1d35ae167fff64d0d6eae4ec11658a25c6896"
    sha256 cellar: :any,                 monterey:       "6aec100f2b1716184b6d6cdc9367f2a87b166241cd91f387a086a7f6dcdfb2ef"
    sha256 cellar: :any,                 big_sur:        "5ccbc05383097d3adae8882bd2d1928637332284e7249515edd6e5ae54bdcc3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09132c978884211b0aa47ec9509f7cbf8b711251731a61b1b933c0a4f00f32b9"
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