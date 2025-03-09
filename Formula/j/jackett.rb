class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1556.tar.gz"
  sha256 "c020a0b06899674c504201fe706686a666f05d040641e4595e91c4878d53e1c0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0710fc2920004859e45b471687153eb0d03753638c0e144c07b00e918591faff"
    sha256 cellar: :any,                 arm64_sonoma:  "f0567100539b715c62dcef7f55ef1dbced0475f680710bc76ba13f2a7773bb13"
    sha256 cellar: :any,                 arm64_ventura: "f1e57b293f416db474bcd49f868677cec38bab263df9db3c0448d85551bbef56"
    sha256 cellar: :any,                 ventura:       "23d4a584ab6681ebddd1102e518b2f48b6babb03aaec1d40605ba8fb65ec13c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d477ebac038edfb3c7f6f6c140087624e2382e64f9d35be07d6a387c65e70e"
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