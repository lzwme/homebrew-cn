class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1052.tar.gz"
  sha256 "f87cbdbfa17165f6da360471d207074caf14035c777796c3039bb4eae4133955"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "945deaa7faf7f270898fe91476782a56cc89e1595310577418e540c81130774a"
    sha256 cellar: :any,                 arm64_sonoma:  "231f9d2ca900993dbc94a8024a4d2891450d33c281f5d63d318fe9b73fb10a5d"
    sha256 cellar: :any,                 arm64_ventura: "224b68ce96e41faaafb7a4afbe41f4542c89bc7bea4113490ed0e2e0ba47c4e0"
    sha256 cellar: :any,                 ventura:       "0ae58bd847a4730a5228d758ce870954c04bed5a9df2a49d103c623a013bf71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc90d0ef5527fe78297acae97c41a5ef862f6facea3af8c38f6b2b03992b9904"
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