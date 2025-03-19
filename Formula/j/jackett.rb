class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1660.tar.gz"
  sha256 "5faa43a859d2a58da679952752043f9a0cc01505a04ca266b59c4e44a0004043"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d1d4280b92ab8db9d665ea5ea4f0e533a032f1dbc0ed70c38f448237a62321f"
    sha256 cellar: :any,                 arm64_sonoma:  "e1955f93550e2e6a524a7c3a96c748064e38707981382e50f54acc7da468e0e2"
    sha256 cellar: :any,                 arm64_ventura: "8d76fee5e1d8257f5fda84f1b94c16a838bfe069bac013d85c9f809699d21754"
    sha256 cellar: :any,                 ventura:       "50bf4fe72b05fdfe8e3d85b92bad7d0417152da88ddc7a21cffed2582410f5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "040a1297751e43bc25dc88cd450b022f7a8a315fb7a5227e5bf56c068fb46e88"
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