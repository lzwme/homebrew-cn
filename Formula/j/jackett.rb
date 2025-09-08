class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2438.tar.gz"
  sha256 "c5c4da9d0b4a706a83ce91d55dd62ce04493f49598ab4e3928a30229b9a12056"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ecf6ecbe35550ba7d16a0bcbfb979f4c2d89264d105afea4cb8d20b7b62b086"
    sha256 cellar: :any,                 arm64_sonoma:  "6a5e4a0b91ba86795aa594a3496d10b82b78aa86032aeffd90574a368fc3ac42"
    sha256 cellar: :any,                 arm64_ventura: "69687c2de4ff9266c42c3e29c3bb272d6440dac3cfbcc8389da99790ec632890"
    sha256 cellar: :any,                 ventura:       "570db44b221d5ed1e525fbb04387988da2707eb79ee7629c042c3e32b0ff1c33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1411e62fb0c1a9293bb51af99eb98871e408fcdf4d6687226cbdd644faf697b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae25a3ba5fb26f58b568aa8d8ce7a76acb6559df2d85e45a0cc84e113ba68ac1"
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