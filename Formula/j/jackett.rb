class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1831.tar.gz"
  sha256 "e945bc34af08ff09e86acf5fe59f5af4b3d19ea44021bacac553593de2c392c6"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c085925f797c1ebbc3da28c4b1bca3590bd47825ef2e9e69e3e16e4f743f2e78"
    sha256 cellar: :any,                 arm64_sonoma:  "21be076db9fc91925f2de675fe22d328009ad98ba1ccb77ce19c64171c3559f3"
    sha256 cellar: :any,                 arm64_ventura: "e2d0745f4b10bd113c75b899864c2b5f200684a4bc012420e3b1690455561199"
    sha256 cellar: :any,                 ventura:       "d37569a0f899bdf1b73c28a99db984321a1ace46890997de5e05b03c7ddb3da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a9ad8e1b3e5c133efa08ed0dcc0e3396757a0725b83a7353235f94ab374aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee01c327d7b44519ea7628d25d8a9e118f2997868b4f286a2ce5cf457c490d78"
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