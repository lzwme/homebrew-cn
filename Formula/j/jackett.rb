class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.655.tar.gz"
  sha256 "279c6d67969c5d04fee96a94caa9c114fb5ee144fdd86891e156aa9bdb6442ee"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f15610b226dfb44a9eef1830fd49fa03239e99dbb87c47af8a75773ff0953ef"
    sha256 cellar: :any,                 arm64_monterey: "b08e041105ea664272e4c255e67675d53a98f75d5fe232cb9cc6d5d6e11631b5"
    sha256 cellar: :any,                 arm64_big_sur:  "6b02b787ac2afae56927ded081a30fe6ca119bd2d8609f5407073cc6af103f6e"
    sha256 cellar: :any,                 ventura:        "22e952564499c829dcd5f1130611ec07552d2e585fd0548b974511ef5763544e"
    sha256 cellar: :any,                 monterey:       "a733912fe976128860b2044a844c990a15117212b9f8da7a45728210f543be71"
    sha256 cellar: :any,                 big_sur:        "44a5c6e0e8dfde3ac8832d1fd155c56f0db9ecd1ab2af82abc8d33e6cdcdcb5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "179dafd7411d1a79a227946911d764edf3ea8880927f2b252f5bd8778f6be86c"
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