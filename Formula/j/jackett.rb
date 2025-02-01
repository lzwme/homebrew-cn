class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1345.tar.gz"
  sha256 "692443b4724520c2d910a85d10959e27d2998447dee2ff130148845ce947a8c7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ecf3eb77e0d6630ecfc9f1ca7130954c94e97308ab8e0bf306ae70c797937d6"
    sha256 cellar: :any,                 arm64_sonoma:  "5cc2f1647109f7f883773ff4509f4c79f811f698097852b44270b05d11382370"
    sha256 cellar: :any,                 arm64_ventura: "478aac518bb47511ec3549de44116f1f862728898a15314444c4e3567f7567c6"
    sha256 cellar: :any,                 ventura:       "455deba64b9ab865210498c88b524955640f5b911e441533f4d7963a2481f058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60aaa82589136396a8e3ac49cb57aad449da7ff109d0153912163c7e8bb93fcb"
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