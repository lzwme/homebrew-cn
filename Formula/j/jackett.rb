class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2075.tar.gz"
  sha256 "d8ce240c90f84fab7c9fd60328eae6991b9416f6bf34d6dae74060f020af244d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f5093fc3b838ff417d9c40232735b4864d3e8d4a64d1dce58a4ef0a5e3dfd78d"
    sha256 cellar: :any, arm64_sequoia: "86e8d5e333475ff93eb5d8b0e3dd81267df7beb90bd8aebf4fea65bddb25bbc3"
    sha256 cellar: :any, arm64_sonoma:  "cd3ea3d64f00d0822408ba3f729e0383f63171a2c524e463d7ce71945ae28605"
    sha256 cellar: :any, sonoma:        "64dc8a538a6331909768e88d86ded0a6a60232e7956a89b87e53214df8633a4f"
    sha256 cellar: :any, arm64_linux:   "bcd47665d00140c8fc7fbbcf7c5832a696e86834b50adc0eae6ab75fefe5b5e9"
    sha256 cellar: :any, x86_64_linux:  "c00d530b86f8a270d780b74c539a00c2dc0bde10e598d2123e7f4be677dc25ee"
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