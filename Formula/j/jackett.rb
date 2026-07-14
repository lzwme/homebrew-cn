class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2213.tar.gz"
  sha256 "3a151f6ea53ac66fed0e7e69e6086c97de7d43210c1af59310bc1b4be946c8d9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "061ca0004a2f9cb95174ab69a7623f626656c62dd308957ee193357515115089"
    sha256 cellar: :any, arm64_sequoia: "8a5b1f58f6914b0fc59f2dcbba059a28ce213f4e5267ee91bbc4ef1e04e17a9d"
    sha256 cellar: :any, arm64_sonoma:  "121087cb06a0f201f84ba8d96af3f156601e1102c743fd9f70be1da2077fd989"
    sha256 cellar: :any, sonoma:        "b67bffad03dda6b2c68c8f71b2151939b36648c7e97d036ab6cf8cf235553c4d"
    sha256 cellar: :any, arm64_linux:   "6f49f3322680ba8a7d5aa0ecfdfeb90d6ca512bfc5859d7150d32a55f197e97d"
    sha256 cellar: :any, x86_64_linux:  "ad8d154d20717bec23cf86b2d80f15388d6734904eb34473f2bfa60afe49eef0"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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