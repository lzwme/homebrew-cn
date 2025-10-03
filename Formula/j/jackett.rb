class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.24.tar.gz"
  sha256 "1815004d5faba0ae0611068b096013e049ce912e11b8c7d16037315ffc1d01ac"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d46ba9da5bd89860f45acffb498c08985b10f41aaf4ecb128c3a25ef8fb559fa"
    sha256 cellar: :any,                 arm64_sequoia: "a40fd8368ce67a2178639ad8d1c559aecb3cb6f7d003f5abfb20d8751c39ec66"
    sha256 cellar: :any,                 arm64_sonoma:  "6ae49875af18090fc8b8159df60f467184b142f1ca3d82acb5695c1a9fe15982"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36badd67e9a256fa1e4a7a0caf0151bbd3deb843d0c9bcefb3d71ea20376a356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bea08db5fa55b249419d75fb2588f018262966af4e427c29cd6759d1eef2d0b"
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