class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1985.tar.gz"
  sha256 "e67bf22dd4a91d8e52fe1dd0bfcd5e2baa84275ada7840d5d4d9a68c5a29e1af"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2466e211b286d81b685dde95e93668196fb5f75977901d3b10397ad63a6f2be2"
    sha256 cellar: :any, arm64_sequoia: "384b931650aa63a0bea4950b7454543dbefbe380fe0b8d78a93cd9c40efad72d"
    sha256 cellar: :any, arm64_sonoma:  "97c5b521119d846f2a557e4ee0cbeb8a77f740b4efdc6cb5ba782352b65d7676"
    sha256 cellar: :any, sonoma:        "018728fb2b1ce291ce396750abb54eb0e395a02c463540737c3dea52eec78dd8"
    sha256 cellar: :any, arm64_linux:   "bb778bd8cf873b071002f19dbb22ede9f9592597b1329f39ccb4fb5dd2d2ca1c"
    sha256 cellar: :any, x86_64_linux:  "6074e0504cf4b0cc115c377bda3238e4acf2977d912c0155fce0ef877f6e6b4f"
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