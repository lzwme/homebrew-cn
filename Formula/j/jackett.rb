class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1996.tar.gz"
  sha256 "bbcf63395ead60a39c3b5ec832d01667ff491cf6e93e64c27f2b8c36a40bcdac"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "277cfa33211fdf1c2c45577d2d48a1d0275fdbb3b8d332353b3ad38e191731b6"
    sha256 cellar: :any, arm64_sequoia: "1e38de6663661c188e6a222de28d9bc097feb598885864c7d471fbff7d93f837"
    sha256 cellar: :any, arm64_sonoma:  "fdb36ef3950c648708d3ef3c61682a17366f7314b08d2246ce105bcaae46dff6"
    sha256 cellar: :any, sonoma:        "2103b14f52c0f3f8b2fa4e35381fc7a584fc78e2a32a119a344eea136c1614ad"
    sha256 cellar: :any, arm64_linux:   "18862ba8c506acf2546e44a107366d99bb214d2e387a5cad6a4e5f632d2f726e"
    sha256 cellar: :any, x86_64_linux:  "f52f871aa4be93095643b0186655528b671876ade4078f5e3de9c7e98ece0d7f"
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