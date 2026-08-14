class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2404.tar.gz"
  sha256 "e3933050131e0658f18f8ed409e5323f64ca08b32f6c3cd0dfbb0cecb7068048"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "36d329ff7d5f8c69d74f78645950e75f00039f21b3cb2514dd54a1262f06f2a7"
    sha256 cellar: :any, arm64_sequoia: "9ef00eb804b7e3dc19bf477b8d8ed8e2e819aca24b6459e58b88d407be7bb05a"
    sha256 cellar: :any, arm64_sonoma:  "b9d6731cd4c3405238281519a27b321d7e325052666c78fcd5f59e7364fbcbc3"
    sha256 cellar: :any, sonoma:        "6c5dd3f7d4ca86a03c9c240b312c3cc20628a8119f3ca1462cc256dac84e538d"
    sha256 cellar: :any, arm64_linux:   "3db33da74fb00fc5ecde4b55ec41eb24eae06f0169280aa316da2ddb0bbd7f28"
    sha256 cellar: :any, x86_64_linux:  "18d8d26bb1dbcf74a3c7f4680fdb5618166b65378c6af1245b156988b7156c76"
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