class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2151.tar.gz"
  sha256 "49e15d9444ebab9671b48f6f3b2f6accdf1c9a10bd0258f2075308bf160bef4e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "28e64dce22d57d401c925bcbc8857b1244afd0a98d8bfa0035778bf8e0795a84"
    sha256 cellar: :any, arm64_sequoia: "286d58bb8e8f0f94a1552c81552d3e6d92c6d95e9791be7179baef63ecce4f5c"
    sha256 cellar: :any, arm64_sonoma:  "c5da8c8fd86e9c81ecb9f70e76bcb183d9b1c0c5decb846930722866b92a4363"
    sha256 cellar: :any, sonoma:        "28692bbedb18b3bee1f0ea9fd03d37675c2132314c8ac8a7687f518447d2c757"
    sha256 cellar: :any, arm64_linux:   "b07a4f18c0f5175e8941b1e2f8d7de710c4a33873fc6dc9f0f8f090a787b1b54"
    sha256 cellar: :any, x86_64_linux:  "86563ce5a404b433f29eea9f81ccd0f5256c07053f3840bea807a6ee9e928955"
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