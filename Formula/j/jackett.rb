class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1109.tar.gz"
  sha256 "7be097fcea0a98305c580811c251b2e92d22b327a4a525e1921ff335bd5c1578"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7de41f0084510ad077571e90e36bb828b4f96cb5ffc03246050ff7cbf84778f"
    sha256 cellar: :any,                 arm64_sonoma:  "579915c3fd4a8bce707e2588a4f88620a3dcdcbb9bd8943ac3521bf25eec0eaa"
    sha256 cellar: :any,                 arm64_ventura: "858a31efc40e6e587d8b2cc9fb24eb128de352c1aa13bd90b8b601e5c64b3ae9"
    sha256 cellar: :any,                 ventura:       "c3f7eecb974b99d3abf817df8724049f50f8ea5510ebc0b3563881bea2c452fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2165d16c82d48277203552c2e88a53901f489ee78a86cc5b43bea9ed584e8c"
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