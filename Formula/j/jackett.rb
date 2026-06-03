class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2000.tar.gz"
  sha256 "cac7455f55a11483fa817c5544c72959a2d52fbd8d92d499bf85983829c0b924"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6fba085fd636e29c93281cc162ffe7ba5986649c22eb7e1b6c1cdc04594aeff2"
    sha256 cellar: :any, arm64_sequoia: "1bafab2da61b63782992678f94e717952b80586b902d2345659fa0ad684c6831"
    sha256 cellar: :any, arm64_sonoma:  "c214f71c317968f4a77fc94997592670e6d91e3f1bcd05dc0e629d105408cb3e"
    sha256 cellar: :any, sonoma:        "d45c7093197a5a1ccaad3909a9db4e34ecde07615a5db2dbb7a947706187748e"
    sha256 cellar: :any, arm64_linux:   "a336d81bba23bc036123f4d61093d57ed76185cd1fe2f30d805c91879a4febf9"
    sha256 cellar: :any, x86_64_linux:  "ce27e0795f9354ec9b7c20c88c98836f59089c273a58d0a5ca174e8d6a270b31"
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