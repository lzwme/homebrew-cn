class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2021.tar.gz"
  sha256 "9403010326502aa6b62f4bb6e840b2c275852f05f8a6f8c33c0661d5fc11ad90"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "94916082cc8aecc03ed032843f668e5e04996a03cecc2a1efd2cd78a4990708e"
    sha256 cellar: :any, arm64_sequoia: "4c7f22adbb161a8c7a3fb8a1d32940eb350462a24536aa606fde15ccc06ab64c"
    sha256 cellar: :any, arm64_sonoma:  "234421f7bc9cb09b39e5e668b84dca169e485630c9ac588790bc04e6170eb3f8"
    sha256 cellar: :any, sonoma:        "273bbcd006860a11d3a12c2815d569af0b78b762032e2255004f6c1dea36003f"
    sha256 cellar: :any, arm64_linux:   "7f94b2b149ede3df242ed113eb28b656494656bc282574b3b4cf65b5f80f8e73"
    sha256 cellar: :any, x86_64_linux:  "dd39cef9cd08bab57b8d79d8a92240366ff99824fe2f6e810cf2950cd8754468"
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