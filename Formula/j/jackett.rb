class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1452.tar.gz"
  sha256 "00e9e139ba7ba0194e939c99db17c5cfcaec53d40b70440c561bc6c24bb65b5c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96fe311454b2127431d7c0d2fa2b420669189cba99db96e6f8c3bcedeb5bcfe4"
    sha256 cellar: :any,                 arm64_sonoma:  "8756d5932a02fd23a6617467898dd6fbe07699480ab0f74f6e5b9bc708efe14f"
    sha256 cellar: :any,                 arm64_ventura: "1275acadcda0eff30d810af977c512620da074015b597b4454b07564281be78b"
    sha256 cellar: :any,                 ventura:       "4c24031699cb483deaefa8f3639291343792f31ab8febee1812019c152e12873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cdecf2d7a1794f06e783db7faf68317e9de2fe8baec3e47e1e077499665af93"
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