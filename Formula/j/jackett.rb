class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1760.tar.gz"
  sha256 "31c2902842ca1de19d63e264a59481015875f8b06211a909d973bd3371d1330a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa23dd2120619c85b00a57d5611f96ab8503346d821e8d12214efe5d4dcbe512"
    sha256 cellar: :any,                 arm64_sonoma:  "16768ae507fb84773565a69f41a6462df39553b897c715a17441a9ce0aa1e190"
    sha256 cellar: :any,                 arm64_ventura: "5b6464ca3cbf37e92889f622822f9753207f516c6678b86ee7049b65af61bbaf"
    sha256 cellar: :any,                 ventura:       "15d978a7b1a6e0d0d219e9c204f8e9c417df41f2dcae541b1bb66f3ae4d7536b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a876787f06cb09e90c866f71c43b478cf22789bab5b350a6fb4bd61be742a4ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e20fe2c3ebc763bcc59d18400d83f33066991c16eac71877843259a05b4be24"
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