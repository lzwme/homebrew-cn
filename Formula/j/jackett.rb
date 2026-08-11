class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2381.tar.gz"
  sha256 "0dc22149ef8caa199059ff05d40616abb6959a7fabcdaf50879f7b380e102353"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d2db948d338fe440d3d433ac67a26cadbb023a0f595b403463d47c5c82348a5f"
    sha256 cellar: :any, arm64_sequoia: "2e3186f9857f16b655da8422e410781b54ee4a6d11b5d1547f6ccb44ad767138"
    sha256 cellar: :any, arm64_sonoma:  "ec2d3064cfc9b5f604559f1e955021d23be2dd1cd9abaa9c3287110ac0c89677"
    sha256 cellar: :any, sonoma:        "2f8d63c717732ef59f5163ce54915f75dec60aaa7da7d5f96f89b018de20e5c3"
    sha256 cellar: :any, arm64_linux:   "36e197c69be029925188c5ffdf77838c4fb6693ec579c556f1a02d55b105e981"
    sha256 cellar: :any, x86_64_linux:  "0db0780f9d8f61d21276b97b39f4c4de363477411e14afa9abd7364c3fd68d7a"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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