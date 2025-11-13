class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.296.tar.gz"
  sha256 "925a3ed52537a982d7ad88ac3a39347f48c336852f144d61a5e90f1a38038eee"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a619aad95ff0526aa755940b2aaaa90aff30af53fddac69f19128d05cab4a4f"
    sha256 cellar: :any,                 arm64_sequoia: "78911ecca33bb5849b4e677441dd641cd122cd65d36375ff312eaa1761152919"
    sha256 cellar: :any,                 arm64_sonoma:  "20d0c13bc72ce571dac08eace3fb936795f924fb4765fc24cbad602a28234a61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020efe01b9084a10ca755b021ffd48e50f74af9a70d040421bbf5b490024013a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c69a3a73abb47b9d546bf787e31e93b04168522570fb52f0b63a5af1d496d8"
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