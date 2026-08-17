class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2414.tar.gz"
  sha256 "8fcee953bdee229536f23569e7fb94c247de396e46255261f3f635fc53199224"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d06a69436d9005fcb999ef2a60ccc8fdfc2ef43c79ad17b3ba46b05809a2a8b9"
    sha256 cellar: :any, arm64_sequoia: "7d11bc067dda03bae1f213392b40233f7dc9466488d463eefc901fb0c54c6b15"
    sha256 cellar: :any, arm64_sonoma:  "dbbd1fa73c80ee2141ae81adac32878753ead56ad63ff4692ee822d35ec0fc5b"
    sha256 cellar: :any, sonoma:        "31914a55d7b91f753e1d7d5b2dcc085ee2567ec5827f7da81a26083fab95e070"
    sha256 cellar: :any, arm64_linux:   "d8d9c2d6401c702febef7d5bb7c2b345cf1351d0c0a7812d5a3c5201dae9bb96"
    sha256 cellar: :any, x86_64_linux:  "cd5c0e90953264ea39eb16fe77cc84c7f4fc9cc79087073d5f0c1a9cda9f61f2"
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