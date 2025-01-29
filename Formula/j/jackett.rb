class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1317.tar.gz"
  sha256 "7471d9440993b9c1b6f913efa5fb6bcb83ed1717d847fa874bbfc29216cf89de"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62246de3746cc013ca1f6d179c835897dfe8652beb03f606f81380841f173ab2"
    sha256 cellar: :any,                 arm64_sonoma:  "06d9eb8d3cd6b835679e0e6e2a5dcff3896d0c2e57ea2abef341fab2418a0fb2"
    sha256 cellar: :any,                 arm64_ventura: "81517ba302ede61718342251a9d05b00c4dca974213cb4d2f6ced7ea124ba267"
    sha256 cellar: :any,                 ventura:       "dc2182b121af2310e8799cb1b8689428b37580cd61e44e3ce4f573a3ca9a7c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9faa0fe2adf1003794fafe98190d27dcf1f0de52469c836c550272871637e0db"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
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