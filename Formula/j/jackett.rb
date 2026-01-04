class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.704.tar.gz"
  sha256 "493adb5c3123553a928cfe2ad09355aad8bb7821e85838bd94caf9f562f598e1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3814a8d1a6c037c515ffa37836dedb18d07ea0f8fb25675e611334df6f2a16f9"
    sha256 cellar: :any,                 arm64_sequoia: "cbf248c87842d676839cfea7b91be43e4b41390c955217daeebc52591f55ebe4"
    sha256 cellar: :any,                 arm64_sonoma:  "0659215555050304c6d46ad25c3cdccaec2d7baf9dd933a0a7b9768c87ce0619"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9ba624a5d2c63d08e213c49e9633813d8998ddab14f685acc4cb3388013492e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd175ae06bf1df3249a061dc2667da4a8ddaf2ddac0bce5e26fd0361407fa94c"
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