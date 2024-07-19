class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.342.tar.gz"
  sha256 "1bc367b3fd8bb6218dd1a2b2726672e46a1248493dbcfebb96d86430e9404c3d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2da62ec15e322a8973223a12cfd357b3d225f6e97c68eac687f8f5aef21fbb04"
    sha256 cellar: :any,                 arm64_ventura:  "419ec7bab977d4a0d27048abef406424143815e71695f198dbb00104ad8534db"
    sha256 cellar: :any,                 arm64_monterey: "31ada7afe508b48176be24cf75f405c682a93a8304d3b2107f694717713631db"
    sha256 cellar: :any,                 sonoma:         "e94294e150a6757886537584096c48f7c362c65915dcd7b08571a32f5fa81ce3"
    sha256 cellar: :any,                 ventura:        "ed219627334a55872cff841339fca6128db82564a6d90a0296c126917bce052a"
    sha256 cellar: :any,                 monterey:       "f1f444b46951b54068beee018defa895982beb416bdd3aa76bcfe4ab15699b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ace7bfcb7edcddb3251ff43f361655032f77826ea6dea730d46ca79838456af"
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