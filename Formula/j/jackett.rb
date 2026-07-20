class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2237.tar.gz"
  sha256 "30a665c14de30ad99252b8f8eedbd3ef470792085b1d58eee4f32b2975efaaaf"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f48c515de84380bd9ba33f188d00ae98ce7b85566f667acc7d3ae0d5a8e2c5c"
    sha256 cellar: :any, arm64_sequoia: "7e7cd6b8c8bf6bc8d3111ebb88270492f5f893d4880e0b0c7b46653c13c22f18"
    sha256 cellar: :any, arm64_sonoma:  "2b4c4813727bb1c5305d2c20f467f7abbd4b64e6dce8671133b4573fe587f984"
    sha256 cellar: :any, sonoma:        "7434d185497952a5aa2d640017ee92f7b0f46db9a822ff839e53a5d8581f0a67"
    sha256 cellar: :any, arm64_linux:   "4ee0b7493d33b65cb5174a3343623aa9a8ddfd6982d48a557d3c0473b76cb5c2"
    sha256 cellar: :any, x86_64_linux:  "7c7a4f012e5ce56e6a78490e71d03b5a039ec4a4c45b7f1f0dee423b466201bd"
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