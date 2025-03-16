class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1625.tar.gz"
  sha256 "51a7e498a001d4a78179f12dfaeaaf253be2e8271e3f4e2420f79c241c0085bc"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "464368d942a82ac00d92130d7592d52ec0a451f28387489d7b88140e8696c3ff"
    sha256 cellar: :any,                 arm64_sonoma:  "87717448e7fc0690622051256e54960c4e3f47f0a90cc362c4ebfd9cc61c3e4b"
    sha256 cellar: :any,                 arm64_ventura: "2b171ccffb21a7c5d593841ec222d8f6622741df6132e8bea505c63deef3f7ee"
    sha256 cellar: :any,                 ventura:       "563852cf59fd2508b05dafcf0641418156b551d4525473e127a708c9e686952e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7a502e6b130fac7387d0c8ef92667ed2f941773919e980dbeb90723d7efb4c0"
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