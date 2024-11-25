class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.998.tar.gz"
  sha256 "2b7f465e02b76beb3b53ff633f9728fd327e2b407c8e2c6efe420e0a5efb47b8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f071c69c71c9c85ad879619002c9dc3e4e7d7e6ea2b75910b3c851cadf41b9df"
    sha256 cellar: :any,                 arm64_sonoma:  "37857f372b724be502b055034c9f9410f1697de97880f2a3501334fce36d2c98"
    sha256 cellar: :any,                 arm64_ventura: "2e861c8a42c8fbfc113af15aef0079d630c593fc136453a45f987095c0872610"
    sha256 cellar: :any,                 ventura:       "eb2a8094894fcbebec32b75e3d4a808429d7392d8b5efa843c4b5aa1d780a5d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67e71a20e111ee2f8d03ebd8ca4c26bbe355d22eff3953a199e437180e75e330"
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