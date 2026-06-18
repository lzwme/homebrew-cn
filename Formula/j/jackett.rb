class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2077.tar.gz"
  sha256 "bec9f3ecb6e188fefa43bd2cba6a9dd3fb6fb2314c8b134781ee29f12014af67"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de1d040e45b7cf690c052d9fdc9f11e349fdc14b30c51d2ae1614a420e511870"
    sha256 cellar: :any, arm64_sequoia: "7218944a987e20bedff5f8acd14aac4affa2cdb3b2aa67edc9e88b0434c6e615"
    sha256 cellar: :any, arm64_sonoma:  "e881b6b29b194d693cc10b8d6a1094c144bfff5a9f92212cfd41876236ca5758"
    sha256 cellar: :any, sonoma:        "fceea0231a9757d02dec0edbe36e1c9332348db5816dbe41ece011fe87ef63b4"
    sha256 cellar: :any, arm64_linux:   "aa1d15d21ea06a072ca34701f19a8df080e243c96ab261d2106d2e435ba8b7a7"
    sha256 cellar: :any, x86_64_linux:  "450fea84e4d4e8258014ceadc8d5398455a85becb001e7d301ccca9bdd9d6cdf"
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