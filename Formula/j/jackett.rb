class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.112.tar.gz"
  sha256 "7c7da027a7faff56de13ff6fed509bc70358eea0ba71f46c3a2431edaebb9312"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3446f8747c4866dc53e5604b4d59b95962d3f0cd2997244e6f8a415ab93fd473"
    sha256 cellar: :any,                 arm64_ventura:  "cfdb5f7ade2766799113f37b8c543974e2f2f7170db527ab0adec70aae3f13d1"
    sha256 cellar: :any,                 arm64_monterey: "8851258a65fee07bbf4316021d168fef5deaf16f0568ff6ce08de7a1142c5b72"
    sha256 cellar: :any,                 sonoma:         "68cc82ab914ea9258c92ea1b31b30810ec7fd1ef0143f73bce4862c3107ea834"
    sha256 cellar: :any,                 ventura:        "5a2db70cd578ff3af61bfbc56c94267f595022c8c2f3954bcdd8095faffe2530"
    sha256 cellar: :any,                 monterey:       "9dde9549c4217eef3200067018536dd035f72b2c2cf952267fa43ec7aaeeac1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf28262e406c84ecfd2248097235a38bbf2f1ba4b74477b56742af3dd89411dd"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end