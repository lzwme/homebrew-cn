class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2166.tar.gz"
  sha256 "165e43adbc8ace02daa3cfdd5b169d6f56d46fa6ab2beb7b99ce373a36596f1d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "253e9a8f9d8b2fffe28df6d663fa78e9a6db9a40f91c20ce22c4b77bbe166c47"
    sha256 cellar: :any, arm64_sequoia: "35f03bd0b53bd0a4b690be180b93bc1bfbdba844c230b75bcb6b9bbb6e6cc1a4"
    sha256 cellar: :any, arm64_sonoma:  "a5cfd7c8bcbdf76b1660bc7ab45d25c0162abe285118534a452399728d728f8c"
    sha256 cellar: :any, sonoma:        "47f01fbbb344237eaba10b5f1cf1d4def0ecce8df188b8a86aa710ffb877663c"
    sha256 cellar: :any, arm64_linux:   "df9f0a0b96e5130faac0f3c495f725e0507411cf654052411c79fb9dc7799341"
    sha256 cellar: :any, x86_64_linux:  "007741d131714ec75f27b6cf6841070784f876147b96ffe3e070719b5088f457"
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