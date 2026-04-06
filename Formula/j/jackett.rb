class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1539.tar.gz"
  sha256 "c858949ac977043921d0ea90ea74bb3c5e07e8c836a4626d68b14123392f7bc4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2e09260e41004c0aeb6f12221a050c0e3b60d9506f071c654f200260da69094"
    sha256 cellar: :any,                 arm64_sequoia: "fcc34a9b07a7adec9ff052d75323f6252416a4742af1571a10c3e9e867bfe352"
    sha256 cellar: :any,                 arm64_sonoma:  "cc236f75882c71b850dc6ff047ebc15fdb847bc918a36e365238866b14dad00d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6996cab84c1964447175042d7e445888e93f7a625d04d8add8e4d6e61378e545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae99c5e6f008b3b22b9f19453d95cbe43eaf9a7133186af91f80b2084c85be4"
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