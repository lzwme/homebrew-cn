class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2184.tar.gz"
  sha256 "279bdb36bbb112c3422d00ee6f757a8d12913cce540a991a12c938af0325f5ff"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bba4aab508e01082d35bc255cb2248a498043673b6e14b44db6c9ceab07129b5"
    sha256 cellar: :any, arm64_sequoia: "e917ba370e2944be7b9ee6fdfcbf0d88ce3bad2640273cb831cf17cb114e9567"
    sha256 cellar: :any, arm64_sonoma:  "212da0d65fbccebc6a9daa9c036e3ded9534a7f3b8b586d1aacf0e45c782a248"
    sha256 cellar: :any, sonoma:        "ab823b24745c43563b4d5e6fef28dab9945c07c9a0d27ad989fb93b407314a93"
    sha256 cellar: :any, arm64_linux:   "78be9927ee612c973a80bedd8044a4e672695811d05a76353189334708b6efc8"
    sha256 cellar: :any, x86_64_linux:  "4f5e1b25555a6f40a817914d139344fbc602515cf422d6c59ed7b497c22b61b1"
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