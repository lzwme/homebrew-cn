class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.222.tar.gz"
  sha256 "66b04956c6f1449b958192d967677f2d737210132f8a8f405f516da96c51cc13"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dea274cf8fb375dae755ea543f52f77cb93f9198f6892e37a20630132050572b"
    sha256 cellar: :any,                 arm64_sequoia: "c5adebd597d7b10d702add75485e8752a375192c93daa329f467a463f4524bbe"
    sha256 cellar: :any,                 arm64_sonoma:  "1e078af6eca0ebb2b04e74a68e99669f2e452ef286110457497dedb4fa266c51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57e0aca7928398d7424e6edc9edf169eaa0d1214ae0a1fb34bc02cf4174c4cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e017ad131c978cfebe297177a1b590e32ff5e67df4aa247f48bfb6541fb4145e"
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