class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1385.tar.gz"
  sha256 "4d07192b8f5b60d4ae2ef8dc49c0768a10727e1123aa78ab3af151b42276b4b5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6070dc1f416125a12eb946847140f6500df7130cd664dd8fcffe9badc80ee0bb"
    sha256 cellar: :any,                 arm64_sequoia: "6ae896cb27983afd039e42dd3125732997e4a2491eaf5258e5057c5b8eb28aa5"
    sha256 cellar: :any,                 arm64_sonoma:  "851d2c4984a5c1d94e9b8766d34d7137e38feb897ed5848fe889662b716b0819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10215d119d825dfff3908d9eee0985b7725f371e6130d0a66da9d5a28b295442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50120b4e08a3f223003991951fa3e0cef0e43012af51f71988ed49883a7dcae3"
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