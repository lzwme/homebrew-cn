class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2014.tar.gz"
  sha256 "f2c2d33aec1ab305af2536abb5d45c45e91cebfef29f6a7d399369921690ad6c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "af13e194107f55bd3862e7cbac23313ed9bb114165b86faa2b2f35486625a7fb"
    sha256 cellar: :any, arm64_sequoia: "bca17e4f23f2b439b1097e4ea1b26c06498c08ffc6d2876e63a5e1942ce6b4f9"
    sha256 cellar: :any, arm64_sonoma:  "1ef5f6010e49811ba4b7483b90764b507fe5e7ebf9595dd9ee05158aa91b75a4"
    sha256 cellar: :any, sonoma:        "7c8addae1c4561787ecc72605e006d4693e3d6f1002cf633236f4c21d7a9a23a"
    sha256 cellar: :any, arm64_linux:   "7315403ba9080eaff09b16af9cded02914d55240abe64791cd4ca3b22f667d31"
    sha256 cellar: :any, x86_64_linux:  "cfbb7cf085a8532a9d78098401b8c94f69d9fbcf7cbfe7270d0d73b5ff684495"
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