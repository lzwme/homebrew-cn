class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1394.tar.gz"
  sha256 "24b7d85d254e4dc2847ccaf60541d20507f937a4b14f3d1feff2e97b22775900"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b0fa3b30c2c10f001b368e15c895a70113eabef1ecfb8a32e7966164626cdc2d"
    sha256 cellar: :any,                 arm64_sequoia: "d3cc1b8f15dba7db2dfa4af5de47d7c5a58e401cd97e2eb1c1539581e1e909b7"
    sha256 cellar: :any,                 arm64_sonoma:  "76e31894bc59e08cb5dd18fcaa0f346e7ef0eb87a97c60e2ee6652d5154a9074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "240929e0e80a89963e8c69e62137098fe783d19818dcf4e6688b78bfe451ab59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "099beecc0f4bda1aa38c6c3e2775e8c024f601c7bc9e62cf033f05ef9cfb1560"
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