class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2206.tar.gz"
  sha256 "368300eba847c191bd17d51cbc29914b9f37dbf051435025b1d32a76ad419a4b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "755d6f7c9c1fcebb9a4007c72cae661dfec55d9b676afaad88f637f00abe53de"
    sha256 cellar: :any, arm64_sequoia: "40408a6c4aadc8d736a3d9bb9d81d323f3ee3af828fb71983ed98e61c3d26102"
    sha256 cellar: :any, arm64_sonoma:  "1a966ed87375d9565e05d91a5d322cfd425e6419cc07fb364528c74994959f8f"
    sha256 cellar: :any, sonoma:        "51ff8f5787a0762d4e8557723d1d2990a1dd63bbfc2c6d1b38cc0637c755589a"
    sha256 cellar: :any, arm64_linux:   "fe26f7882bf82e761d1d40209e271ccc5127f5584d1db473fadf9f4776ba1810"
    sha256 cellar: :any, x86_64_linux:  "04cc7cce3890b4c69286b955a183bd5d3aa42e1a2b56283d0b4f9e419b6bd85c"
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