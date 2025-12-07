class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.408.tar.gz"
  sha256 "2797251cb8da07b69183c982d9d8d064b2c60b5868cbb4186c1b8f3440ff6aaf"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45521761e17d73bee6326e6918198bdf2568faf6c05cb819d1e10d3cc11c4dc3"
    sha256 cellar: :any,                 arm64_sequoia: "46bb9f763868fdd8d9d6c1a451a254f78e2fdff44577d8749ca2324b1446eae7"
    sha256 cellar: :any,                 arm64_sonoma:  "5d3389026b3f55e777764f55fef19dee8fa2a21e96b015324dfe8563a4a84989"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8c1085f376afd9ccae0244158ad7a18d889deb04182b9f3104929e71a538433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620f5021b1508aff152f84604b2a183226b77dab68d2b6bc39c5a7761a084310"
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