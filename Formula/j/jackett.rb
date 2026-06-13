class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2051.tar.gz"
  sha256 "725b6ef7062d569a9eda78f16a8db97386e7218a6ddd98660fa81badeeea43b6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "988e56994f453464a5e246e3ff54a39ac5af24f5756e30747706832e1ad3d03f"
    sha256 cellar: :any, arm64_sequoia: "5e66cff77b62af4b8d8cc12601bf01f9450d3b7d795518fe77b2144b61626e6c"
    sha256 cellar: :any, arm64_sonoma:  "f4d0f85cdc8c4e4f598dcbe066ba596f11e1d32298725d65f584f962b2e22b04"
    sha256 cellar: :any, sonoma:        "450ddfb41f91522cb6fa82038c4239dde644a3c29d66fc59534fa8dfdbeb8ec0"
    sha256 cellar: :any, arm64_linux:   "77fe7cdbf7a4dc3ee4617b43288407a6a6bdd379bde6ca1a5cbacedb5f49af48"
    sha256 cellar: :any, x86_64_linux:  "464abf39fea98164042cd936e36d327fdda40102806ec14e3e8c8953318a6e8d"
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