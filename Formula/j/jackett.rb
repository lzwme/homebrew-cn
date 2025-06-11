class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2004.tar.gz"
  sha256 "db10c04e3611d6e5061b116d7b62701f4f4d9439a316a7ff1da45b856aa19daf"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "71044885bdb500035d9f4f1062668c20cdfaa85ed46f2581e3ac20a8b659fbea"
    sha256 cellar: :any,                 arm64_sonoma:  "e8ae1b6e208064ce6f5cde7dc455d9a5c8eeb390bee3fd16c1de1c59651f6016"
    sha256 cellar: :any,                 arm64_ventura: "559ba9be5c5b14ea6b2d79e009711ea324fb5b9b16f50cf478d91c0d699a5ba5"
    sha256 cellar: :any,                 ventura:       "d4e3992b79589a0dc8fc9c15a36f267a47f811bd069d53a100646b383dde2970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f113b96129c4655ce23f72f533103bdf6b44b5a527a942193b7083732c2720bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3bd4f3b7fb151cfcf4bff759be63cd5b96645faf43f24c7e7a9615fbb0b5fd2"
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