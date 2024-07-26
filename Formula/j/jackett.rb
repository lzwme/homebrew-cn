class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.364.tar.gz"
  sha256 "1cf65759952ab770b0feb6dbe29575b48b50aacc5120e8bec5a08971bd0e7856"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "debf89794eee0a91aee6c52779030b962200c96b00060e812a1d87be3500a17f"
    sha256 cellar: :any,                 arm64_ventura:  "e0a8a0252872bcd447914b5bd8898e61a16cbe77fe0138de05eaa9c320c4c05f"
    sha256 cellar: :any,                 arm64_monterey: "8bce4eac135b67a8b1f17dcb52fd95880355bc772e560085b29ad284b3f6f02b"
    sha256 cellar: :any,                 sonoma:         "a6564fc7a5da17610512b14c360427f8e9a8a376d8407111a16314f561b584cd"
    sha256 cellar: :any,                 ventura:        "9b462015af9fc5483a6a4b142515e2d785362dc6338596ac2a0eccba3c8d3908"
    sha256 cellar: :any,                 monterey:       "76da2bf09c5edf217c89d62d98f4944e1caf1668c3c3195266a3f88421214bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c347a40fda83aaad4a93b1d63221d50e93e2d86c61581492ed55989325f580e6"
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