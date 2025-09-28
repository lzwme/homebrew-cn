class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.71.tar.gz"
  sha256 "b9635b08ffe16e766b8562fd785c930021425d67263c966624489045fccd5ef5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4fac7e16f3616426b957047d43278532892c2e79e7b7fc46cf61b8c5ebb47451"
    sha256 cellar: :any,                 arm64_sequoia: "d0c15b9fe70a08e2726b580b71e2aeb69460e4494fb66f5c198cca0411efb677"
    sha256 cellar: :any,                 arm64_sonoma:  "89bad8dfdcab6db7a241fbb799aff27c21092b5c66f8bea7782de324d02bf56c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14af0b31d94dbdb709c93c89c39dba6dfdf028f35fd2985842e4ffc3e6840be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "362f1e4a9c3dd0b77fddb09ed793b6a667dfe93bcc5c5ab8c9035c3ccd692c43"
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