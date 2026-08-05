class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2327.tar.gz"
  sha256 "e80445f9e3387472d26a76b8f41446875fe10c9e78d4426f3c0c547e0089a6b1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2aa704f87a69ca4635138062e3a2708280a6fc76f447d62536b2dbb54c652029"
    sha256 cellar: :any, arm64_sequoia: "ac75295bf4e548cc7b29b69a251ddbde62dee854efcfd79ba3751bd6f14ee011"
    sha256 cellar: :any, arm64_sonoma:  "2913dace6a7ee7b337ac690ad0cf60dacf8e0213d8f47a8497f449e4337f8cb0"
    sha256 cellar: :any, sonoma:        "e1ebbc576613ad7f3620883669a747d8a73070444f8c7000fd7ed73561f568e4"
    sha256 cellar: :any, arm64_linux:   "f82328842d7fdaca7ffb52f76ca6d4ee4cf1e41f63ce08dc91357ac927e9d26d"
    sha256 cellar: :any, x86_64_linux:  "14a100f4d8fefb6f290734c1ad9e59156903076b5f6b1aa68a4c2254bffc994c"
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