class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2251.tar.gz"
  sha256 "4f1a29524e6229cfcdf14108e64fc5b0f11d9a9761d089f42418c936f26678ba"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dcb2b537e24a14caf5d4315000410bbb4c4654ffb582c23d6d1636fed50576fe"
    sha256 cellar: :any, arm64_sequoia: "7b508816b2aa65ebd167141e803adf3d3010ee450b0657a935d8b83ff91ccde1"
    sha256 cellar: :any, arm64_sonoma:  "06552d1b5ab5618ceb0594388eb105ea51d2752124112169ecdcc688bb3e82ca"
    sha256 cellar: :any, sonoma:        "e8119252624badf08b3e142ef25f7de28c9779e3fc6e3f9930578c0cec5946ab"
    sha256 cellar: :any, arm64_linux:   "e52e9dd6a71fec93036b2802dc05fe0baee81f074132842e249d483b674ee589"
    sha256 cellar: :any, x86_64_linux:  "4632251355ad9478ba5a9c92edc78c7055c9ec44d133268a79d3be9c75895f67"
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