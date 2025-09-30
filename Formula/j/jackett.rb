class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.87.tar.gz"
  sha256 "8d61bba5912d583b73c348681419423875e69752db0b4cff63b91e655180e93e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f62f49c51a088c5119da342d398198520c61bdf27534a00d896d2c1edccf9f0"
    sha256 cellar: :any,                 arm64_sequoia: "79f5c4ea5289ea2139cb8bbbc5ed72829dfa816e7bc5143b654848b7378d069f"
    sha256 cellar: :any,                 arm64_sonoma:  "63bea29b574284bc76b4c238ffecad743e830dfba6283a3ef6f20be98ef888a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "064be00846126724cbb9eb35c0927308f1e3134cf8f20316af2eaaeab7cf1a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c795007fffb362746bf972d761bd6dc785634f124584a9051179f48f2ad3c6b"
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