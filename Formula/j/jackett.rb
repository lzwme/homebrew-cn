class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2110.tar.gz"
  sha256 "a866c99fc362a613ecca6ae508e4f2fad6d4b15ce2358065c503173a009423b4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "35063995904f01b8b871974528333bd021ac7b3b31340caee00257def397778d"
    sha256 cellar: :any, arm64_sequoia: "4b0fd24f89499f2fdd0da3b9c8e3c79e49202fc99b54d0b1c3fbd1650a81c78e"
    sha256 cellar: :any, arm64_sonoma:  "4f9fb503691a5ab0e58cb24725e7ba04d4b00cc20c4941b990ed38d0b4c9052b"
    sha256 cellar: :any, sonoma:        "c461a7da9b2f13224968650f3e83b3d7c278a3b14a3e2b4b10acc52511551e90"
    sha256 cellar: :any, arm64_linux:   "c0fa699c071a157b27599d3a8b4461c3a6a1a08e63ff8a6bc09325f0f92c2f4f"
    sha256 cellar: :any, x86_64_linux:  "af18345f996ad948f788e022ccc1c2727685c7c0904a16fcd24ed71a463a0154"
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