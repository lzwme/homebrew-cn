class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1098.tar.gz"
  sha256 "c22a62b927d3235d236d839993dc0c1740ba4dbe90ade645eb965c94f5218f6a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6318ea739a04f1027d8d7107a2732fdea2c03b8f4848efaa501198379f8cf03b"
    sha256 cellar: :any,                 arm64_sequoia: "4281e4161cc1ad3c936e1bc17888bdab5950c857de834f8fba6a9442748d33f1"
    sha256 cellar: :any,                 arm64_sonoma:  "7e591cb45f380d590a579eaa31da991179e27535491262d20efc11b2e97a81b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea4eb0dd9a7a0f14a683700e656900e4db4dc7686efb0066490177236d175195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb2482ebe702c2fc2da4a2e9e46364e6897a57200c01a415f58e3b60da1c8c4d"
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