class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2122.tar.gz"
  sha256 "5dac232ad7a4e0479b337ccc62ee1acfef16b923d32901ace44d597cb9de233a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "69cf45dd994d2cbb91b90e082569d5fc60ac994e77bb0447828324be75c9ac6f"
    sha256 cellar: :any, arm64_sequoia: "bb54b14c102b6b8281d3b62c579ada8f03b8645bacd91377a39b9020196270df"
    sha256 cellar: :any, arm64_sonoma:  "93acb303078db63010f8129f4bbdd44e7201b46bb76465827cc80b106fc17555"
    sha256 cellar: :any, sonoma:        "bae468f0e3277d79899ebaa06442a9285e9e91e9bb3f31263538ce2ab5e212e6"
    sha256 cellar: :any, arm64_linux:   "67b668770d8f654ffb2cbef5e6bb68945e0abf0ace897cf1784a3da7ce1ad6cd"
    sha256 cellar: :any, x86_64_linux:  "0ccb88006ef9a57a1a3738b50622af711fb805f287e1e07c44a57e430d1104b0"
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