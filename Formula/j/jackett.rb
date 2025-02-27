class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1459.tar.gz"
  sha256 "cb83e91096fe02108714aac29653e15b874f4cdb6296b9961bb1e72be79f3e08"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cdbaa6623845c4034a1ea17d5f1782f64389893c1f5f0e93a55ed19b331cb793"
    sha256 cellar: :any,                 arm64_sonoma:  "34be2b86cc827308c61b269e3c6c6b7e0b44a802e9490d03c7f32f0aacb23346"
    sha256 cellar: :any,                 arm64_ventura: "25ea7d4faa9add2d78cd48915887ec387c75766e76bf0af2d518d0c3855babe4"
    sha256 cellar: :any,                 ventura:       "bc3502d7977eab8706dffc6220071a7b3c9e01fb7d6a721169f4ed9334469228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c03acb5424641686269043ddc07baffafadbe7e3d40b41c7d5a37e06ebde8d8"
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