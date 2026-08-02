class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2307.tar.gz"
  sha256 "2453e28899180599681964c1a28cbe5e0f065f78ce55cd448eac505e64f29327"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b9e4a663e89da9c076667817d1bc894a80e42a4dfa1952541a6905daeccbef0d"
    sha256 cellar: :any, arm64_sequoia: "13a9dafcd1e8829621a6c070f0f36d780535802f8852a7dcbca5e9e2203f72f4"
    sha256 cellar: :any, arm64_sonoma:  "624f1247064a4d9fafe9c6d51d72215dd5cdb6600fe63ce703da89c0f3817c26"
    sha256 cellar: :any, sonoma:        "ced225f3c5a19c78696a0e178eec0aa4145f319a09cd6edc723c8b00dc6f726d"
    sha256 cellar: :any, arm64_linux:   "34470447c36c7e530e43254143406f7016cc8c3eefa58968ffe19c975c6de53a"
    sha256 cellar: :any, x86_64_linux:  "668141c317aafc96873351055036ff4b7a346d7e4473a12c302061c82b660c4b"
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