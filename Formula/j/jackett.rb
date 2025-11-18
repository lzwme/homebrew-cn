class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.319.tar.gz"
  sha256 "da2b315acd175330d9ab2262d240980c6959a749f0e9ec6515f3cd26ef068004"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3637135b70f13012d94c99e121b9dd40747388d030f5888c92e6e51dcf47d16d"
    sha256 cellar: :any,                 arm64_sequoia: "d4c99d40cbcea01fd520dc188a8b0f51b24565305400f7a5e8f5a274348645dc"
    sha256 cellar: :any,                 arm64_sonoma:  "63b63710b601b6a56bb5c28660d19c6206f94ba70f383c2cadbe4e29ab0859aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e52ec440c833281beed24399c4308b8819ba1742d6a70dffb0d21a927724b953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f954f1572460bcdc87dcd7f2ce52414d68089d6ed3849aedfbad4640132e9d70"
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