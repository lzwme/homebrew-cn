class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1018.tar.gz"
  sha256 "9def432ba8a1a6a1ef01a480ea86db57fcc9e8f3b0034794c99070e94adb2d1a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e64c4b138ba1e760f9e73d05dde9c95df6d2cb34c49f8b0cf73ff1c8714c5690"
    sha256 cellar: :any,                 arm64_sonoma:  "c055ac1262677df8e13f0870880986689e090ebdbc40c22a502663d336d7dd1d"
    sha256 cellar: :any,                 arm64_ventura: "71d629aabd33f4960ff93fdf4aaafb557a926d37a0d2c90fca3daf01cc2573e9"
    sha256 cellar: :any,                 ventura:       "f0b9e3c6a0366987d8deec3e2e6c869fc6e2b81b604573a26de675e922971ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70f49c065c531c33e582d1cc566c8b3c444e29577abed661a7145aedd5bc926d"
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