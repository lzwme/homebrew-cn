class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1795.tar.gz"
  sha256 "60aa08dbaee8d95c4cfa3e9cb58247f7cd752904436de849dcf76320f294a2a8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16858393bcc31766a3515010e9f3652ed5c5ed928ad1f8436b254f0e58fb60fc"
    sha256 cellar: :any,                 arm64_sonoma:  "f3ca3cca5b17dce204a6a62dda3d3e451221c2d87a0d569595c8ed313726b168"
    sha256 cellar: :any,                 arm64_ventura: "c8d767e96ad2b9f43b58ded00548113bab31eff589996e1e4c0c44a5aa4f0a78"
    sha256 cellar: :any,                 ventura:       "d07dddffd857846c3ac6b90f0ec07c6c56bf75499b216607fb54d22d19813b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b49338d124167046b1f9bb24003ea4b2a40760a83a93efb00235b3b562c9e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d724d620f95f2369fbf1717d100680ea949065ee868f46e67b91d7ecc9b2f6e1"
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