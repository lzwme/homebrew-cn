class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1941.tar.gz"
  sha256 "edfdc03c5ee2a1a15e64787ab44a83445bbf739bb0db87e258c23b80973ccdb1"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4608a92ff6eae461c1097566220a442ddec1ee48810ed4554c8ff0dd2a125ab"
    sha256 cellar: :any,                 arm64_sonoma:  "1b4fb419f3aaa0def91f252212fcfaf5b15240aaad0132bcf2bcf4b989a4ead5"
    sha256 cellar: :any,                 arm64_ventura: "ab75162f0d68d5a6fedd3bf20164d6c1b7e5eaad94ad2c467ad11acf1345ee6b"
    sha256 cellar: :any,                 ventura:       "33f386f0d0bc494ef86f6af346a72da330f33f8656ef5fa02ab30e7995babbe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a42ac9902ce07ab6bc739b7571b49e7b505713b3a30cc56e640a1839030c1daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59ee249d32e4378ad80cbe6255f2c0b6b33b6cb902149cde13840d62be619020"
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