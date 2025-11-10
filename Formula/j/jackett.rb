class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.268.tar.gz"
  sha256 "fc08c60c0065cc39c534ff57fd5f567c3565e71792a029ef8f348228bd0f3378"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c1984b3f4d4241f2c40aaa25d4cd7d6f7f531aa52658fc85786ab98afbcd15f"
    sha256 cellar: :any,                 arm64_sequoia: "a2cf96a2e0922c8525118f1c232ec5335111aedeebb2b0a76319cf0449aa00c8"
    sha256 cellar: :any,                 arm64_sonoma:  "38add8e2f6401de55bad13cec6d6a6cfbd9fb235c67fa2ad1740e68b305df6a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b498e7ab7453b7a9efde3b9a6693db170b76b669ee485c31eb8d7b1b263cfdc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "227311e2c71f05cd08f0b94bce94f7585fc6a2b57f92687858e252b2d2ff1df8"
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