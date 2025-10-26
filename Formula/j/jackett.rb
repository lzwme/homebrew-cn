class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.185.tar.gz"
  sha256 "9bdbc2cdd907569138e38a657e9af6e4a8166e350efe1ab6245bd6843a92ea67"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d4d40c00058f78cc2cef3ed6b86f29f0b7a31c85b366c102f7779ab6b3d452b"
    sha256 cellar: :any,                 arm64_sequoia: "8a09ff762056a0fdff7660f2454490bdf2fdb3d787c7c92420c7397efc2b964a"
    sha256 cellar: :any,                 arm64_sonoma:  "6ed2554224b75f00f16de74f81ca9f5e7263df0c70e5974e97cc85adcd52d163"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "623b8e3c1df13bf50fdf7b82545a0daf665264a622582ea62594ac24d90f67b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d5b63db68b902e04520e7a3a258236e50d5052dd196d912a73b067111cbd4a0"
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