class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1101.tar.gz"
  sha256 "249d05a8f03473d0ac43a1386630ab8d6f966c9ce8f5e51caa66523e7355c2b6"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7ea747811d34cc217edcaee9849238854840c1d27f9947ad62fb770255caba9"
    sha256 cellar: :any,                 arm64_sonoma:  "02052453350bdc18464551b9a01643ad3e5d8aacc333fe184c0b382f958f4b5f"
    sha256 cellar: :any,                 arm64_ventura: "63c183888a02f5c63196d73259cc328c94d42b2e5de109b67742c4456c4c62b8"
    sha256 cellar: :any,                 ventura:       "a6a3fb951d61f6c3afe5d686d1c6b3c42ae6a278cc53e86e4acd27287284b3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7db3e88f94361f5f6e1bb8a4ad9bd66c1b49dddce4610d74ca3a9f577224796"
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