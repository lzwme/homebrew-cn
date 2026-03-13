class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1350.tar.gz"
  sha256 "97afc0402ca7600e809e00a6404f37ab6b54db27bf3c58710038fc5b0d45fa0b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c20a083ff9a92f81481645f28dba80d49fcb3809af9a30ba9e4afd0a063c5cdd"
    sha256 cellar: :any,                 arm64_sequoia: "64e5946f11f3e2c904b4630ecd78a66f3eebfc9133b84b2a530e385ad925847a"
    sha256 cellar: :any,                 arm64_sonoma:  "a3b73e50644a1a9205f6933f520638c08d095c8bd5e39294ebf96cfa992027df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f39fabe55b7f3fd2553a5e14a5765f299ce84d89d1734bc66d784797ae53f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad5c05efb18c6ddcbf447875e81884285871fe977db25654a5dcc43c6c8e61d9"
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