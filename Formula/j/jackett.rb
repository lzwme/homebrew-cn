class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.420.tar.gz"
  sha256 "c4ef8b95dc11c6953457ead5cc2037befe70c2e94d7850e2651bca5ab48fa728"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7387fae274832226f85e76666ca7dee971c854d5084618622777a73342db1e07"
    sha256 cellar: :any,                 arm64_sequoia: "9d1f5353332acb6c6ef699c76f6cf9d1d617f5bbc190a874152d7f87c84a5b39"
    sha256 cellar: :any,                 arm64_sonoma:  "601634c65142444f02487029c2de60a444b3f1e439a167027664aeb21a6e9534"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a60ce7b4feb20f65a8b24fe477ee9187b7ab21c993129f2a7392a752a1e206b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bae135b1f2f24e4f7b964c095146d3949d5de9cb9fecee84931f0da9a32eff33"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end