class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2406.tar.gz"
  sha256 "1ffcb36cf7e0012da906805d4d7c62294034d24cad947496d4878736f91e2178"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0236f03c4ce4a57219b46935f2d5a5418f7e66eb40e9a650fa9d271ec52708f3"
    sha256 cellar: :any, arm64_sequoia: "564184c34694760e0c7b238b2eff351c8131006d3739114a5eb9e26b6be56b7f"
    sha256 cellar: :any, arm64_sonoma:  "a5bb78198b5ebb1d014ed1cb9f765ba5d39214f0be267b9dfc1d2428bd3e0981"
    sha256 cellar: :any, sonoma:        "1830d893caed91dd3f958b5871b062e6eedc0ea61d45416fec58cb5f1221d467"
    sha256 cellar: :any, arm64_linux:   "53a1bd86009df1a8795c231992266f3a7f8b674fdbc2e5ec37956dad09a8f995"
    sha256 cellar: :any, x86_64_linux:  "533e847ceb47d588a09bca5c67c6daa1e6a2b4c30007563e79e04131e34cf8ad"
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