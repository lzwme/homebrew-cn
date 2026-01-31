class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.988.tar.gz"
  sha256 "0aa62599496472b31014e81b134660b6563382ab99156f4a95f48dbf4e22cfa7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "042bd2c07c51f9278f444faba39d414105151bf6ee7c8fbe39c226eb8f5f92a4"
    sha256 cellar: :any,                 arm64_sequoia: "a336ddd0d1f6e8552583b3cde6dfb29b5aa87c6822b41d496ebd796aec0fd6e8"
    sha256 cellar: :any,                 arm64_sonoma:  "9669908e1aff3d1e2a93b3179365a1b992a03d4049d19b3059d3e21c36b016e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9ca42aebba0a436c4297f48a2c6440ca5c4830b6c1f040f8ec00145fcdef3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b57866c25329ef110082757fcf850a00a586718901ddafe8510dce59d4c49e"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

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

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end