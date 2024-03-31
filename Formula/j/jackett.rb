class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2219.tar.gz"
  sha256 "d3c191c4860daed41ea3fdd45222bce377837883998ea67bdb5eb6184521312d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af65e91bcda9b67f5ff9eb66374a7639795f55a5c9c8348019b044f91aeaa75d"
    sha256 cellar: :any,                 arm64_monterey: "d470ded7de116d79511b2c5b6979bbe6848878341d6d46c35242c84950b57445"
    sha256 cellar: :any,                 ventura:        "9cfb1ff9dc24a5704d0f17ad07dc66fd3605eee84ff0450bf7c39e23ad838dc7"
    sha256 cellar: :any,                 monterey:       "be45bae8d18f01517cce9d2f2bfbba3272a30e68e05119c40c81cf17304ba6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e503b49011250965e1dfbac0432a1eb1d9229f39f6db708d1ac68e4d728d06b8"
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
      sleep 10
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end