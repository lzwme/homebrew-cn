class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1316.tar.gz"
  sha256 "ffb02876e6569e3fb653628b44d11fd6e0c12bb0e3aa06e39c1e44c9e0fc8c80"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41fd477bba060a4f6a5072218c9b99fca69ef21541b5c39c94aece541a628598"
    sha256 cellar: :any,                 arm64_sequoia: "54b87ac9a6798c24382df7833463bc521d237c218a094a10d3511bc6ac888fbb"
    sha256 cellar: :any,                 arm64_sonoma:  "3f28ed6fe093054d88c9b1e87d81798eb93e75af47ee8a2d0f7aa8a45c6e70f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47d423aa4b93e9d0a9b11e46a08c4ec18761f5f4114b60b5be002c5432b869ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a951d36c37ec7a794b2ba80f583ca099bc6d75479aea7837fdcae5e7d0335f1"
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