class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.726.tar.gz"
  sha256 "16c6018772457666a2f7339a6b62e646f94f2d58772e0366ed9be3415f3dec14"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "83af8080f4cd55e05772bfd4c24f749009dd2b169608715474156adc93dce825"
    sha256 cellar: :any,                 arm64_sequoia: "1fc2a7be99b858440624e91c8b402368d97e22cb7282c70b81941a9430d44853"
    sha256 cellar: :any,                 arm64_sonoma:  "585105a2e1e64315e73441d433056d0c66c30e1c84046ac60fbe1e1446b7f4cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f183b1568191584b3187024bf6e3820c6716a487fb851a00b35d99cbbe76164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c517ad14941391675e38d8ad0faedd04fc25f91e4635d1677ba5020fb6c710b"
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