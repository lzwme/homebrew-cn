class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2205.tar.gz"
  sha256 "1b92cc83ae05b62f49766d1c149d3d873950851a576402f95ce522fdb5c0a0f4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bec4cb2ddde2c2056f08e6799391bc35cc09cb62678c0aaca1a404de75c2a764"
    sha256 cellar: :any, arm64_sequoia: "dba0d302d7970e73157cbca8798d4311a6144a7a564f198ea262c839d011b88f"
    sha256 cellar: :any, arm64_sonoma:  "9d321b66209b54c78aa1e834559c435ffd89d22e185ab52c09179c815b9afdbb"
    sha256 cellar: :any, sonoma:        "760a743e0e50a67430613a7dacac40e2f8d6e01bc35cfd1a8a085971b8153c9d"
    sha256 cellar: :any, arm64_linux:   "81901750821b6e14aa8bbdf3892e20b6c1c2e2b3126a387abb56a65254f4ae8e"
    sha256 cellar: :any, x86_64_linux:  "05a3d8d1b3d3aa4911cb90ba5189c9fd9ee111c1120fa7e46212c02e3a33403f"
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