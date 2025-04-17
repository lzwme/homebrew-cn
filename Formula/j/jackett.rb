class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1784.tar.gz"
  sha256 "9950a33b8b433d5f4737b4e47cab20416f2d9bf61b805ebcc7bc2a9d633bf624"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7fa8c023e282aea2f3362cb506f6cb3ace5efdf22e7effd0bcd493173c7d46c"
    sha256 cellar: :any,                 arm64_sonoma:  "1ea66b6c5e151dc048c0d70405074c3dd4bea9f5ccd7fd286daec78eee171534"
    sha256 cellar: :any,                 arm64_ventura: "be61400860e02958b0eb4a04ffaa8ebaa360f1554c2ff02b058a69554b987835"
    sha256 cellar: :any,                 ventura:       "60562b8a20a2a8a8aa3a3fedea934bcf030c0a2e592f349d6cff8ad3c543c308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2a04c54eb466dde24902835c5f1a6bf744d0c222dcc1538e7d7c1f686970266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f30d200c4ad95afc665e3890123089f5edbc97165da912211821c13563cea6c"
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