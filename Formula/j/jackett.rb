class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2226.tar.gz"
  sha256 "68eb423a9d791f6eac934a360486d14f45d84988c15034d940fdcb0b44d4966f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "313504c106ac41533204c1a0bfb0aa5645e2b534424e668e96e9ffb9f68db915"
    sha256 cellar: :any, arm64_sequoia: "d7b1246d2356eec223f5164deaa792579053c8c29a220388a82f2104200114ef"
    sha256 cellar: :any, arm64_sonoma:  "3cd0bfcb0266e59b133a9f2770888e1c9da628c8aff92e00e9351750c2f30e2b"
    sha256 cellar: :any, sonoma:        "837b59413e5a697ac464b6411fa9936eb32788918b51c11628d4c90d5a1119a9"
    sha256 cellar: :any, arm64_linux:   "c99592b048908684ea18a19d9a7e412536815ddcabe6a0aba7f64f44c239638d"
    sha256 cellar: :any, x86_64_linux:  "c18b36f3f7df6c7c47db112be8358fdf44b5032910dc074e0c585c9df368dfb7"
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