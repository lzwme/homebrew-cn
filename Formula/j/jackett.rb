class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.457.tar.gz"
  sha256 "39b8154ab258ac81c4195632aa0627d5b86acc75922bc13440a81c74333c9a6e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ae10196cdf73656b399173a5c5b84786699082e2957c10dfeb4c1e3ddafd0672"
    sha256 cellar: :any,                 arm64_ventura:  "a61b3bbfee6714e82c22e80c29c7e7960b6f251c7b14e5e5118d75cd022d9460"
    sha256 cellar: :any,                 arm64_monterey: "54697e28ac093aeb8e50e859e3ee1b4e4b87ea8c4e9bda5245b019db2ef05462"
    sha256 cellar: :any,                 sonoma:         "b6ae4541db6e03ab183a2bbd895769c2040de5331e34d43509b8c5eb14960165"
    sha256 cellar: :any,                 ventura:        "fffe7b3acb489ae29ab5d58b921b373cbb0880b1a34884f711eb82eca703aaa0"
    sha256 cellar: :any,                 monterey:       "2a3d289b117c4900685b09c096f43506de58652ae692b7a31069b752cde5e5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bd6662128d69fdaa3523afa703ae4a7533026fce64bad06fb5d1ddaac4817cf"
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
      exec bin"jackett", "-d", testpath, "-p", port.to_s
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