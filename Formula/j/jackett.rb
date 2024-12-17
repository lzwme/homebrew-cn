class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1085.tar.gz"
  sha256 "655ff667524b20b05df0c9ce347c5c89a85829014116f2b3917d194ec752f1fd"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38468f3921f436a56ab239f6283c692dac82a31260570b1230e2f05e8e66ccd2"
    sha256 cellar: :any,                 arm64_sonoma:  "33b1dc3da410f501c4ddd88c3b3a58b654314b65c7699516f19f70475a2fcfcb"
    sha256 cellar: :any,                 arm64_ventura: "9d85a99c31b2572d1c5b6aec2ad8d88a864ca9b123b13400662575a5b541a4e8"
    sha256 cellar: :any,                 ventura:       "4e5d821469b485b6f7e10856b006414b004dfcae75cb99db2638eb8be23ef4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f624f032e7b11f6143614e09b4771a50d0355ea31b5763245f33f03fd6e9f5a"
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