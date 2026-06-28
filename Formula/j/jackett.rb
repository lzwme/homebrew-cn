class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2126.tar.gz"
  sha256 "6ef9489128041e05764b1b71b500f294346ced3aadf395ec666275c77639c81d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "023db40cf6f5e44755f5bd366a687dba0e15fdb06c56677cb29a537baaf16576"
    sha256 cellar: :any, arm64_sequoia: "ce7b9844b59265c4d7c08c452a7f35ddda13ff048c8269f50e809beb8614120b"
    sha256 cellar: :any, arm64_sonoma:  "411d3782e55050cab70a9fa5d0d6f3fef12bd1849eae282037c19d4bf3011e93"
    sha256 cellar: :any, sonoma:        "f872c4bc9987e535ffbe413b8b4840f63dc0380836d5f4fea10ac044b566c26b"
    sha256 cellar: :any, arm64_linux:   "3a9b125b39704de0d6c6cd96dc748e37880072a7060f944aa8f5d5a6f227da5d"
    sha256 cellar: :any, x86_64_linux:  "32f14ea39447bd2f3eb4d0b9ec1e7eb7976e29e27be020f241f3b3be26b10190"
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