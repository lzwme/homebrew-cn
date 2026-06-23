class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2108.tar.gz"
  sha256 "51411ca71b0fa58f42311d798a650a8e280a8670b1cbeddd9146a3b29fd3e3b4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "67f444083a490364c1ead5a1846a6f09673b8f0e770b0ae53641a1fb156a82c1"
    sha256 cellar: :any, arm64_sequoia: "58bad9b7944842bc39ea5385f865809adfed1d1b4ea6202ec622a6f1fbfce96c"
    sha256 cellar: :any, arm64_sonoma:  "4e6d94b53ad0142b3f0750eea9c119fd3c497ad9998f9a038e01d3968afd3329"
    sha256 cellar: :any, sonoma:        "f2590b0859cc1011db7929e156197fec3ed065e90ce3102666bb1c5e357f75f9"
    sha256 cellar: :any, arm64_linux:   "026275d75d54cc65e00c0ac3c74ff46f749200837d642c21f9761f55b5703800"
    sha256 cellar: :any, x86_64_linux:  "e25857fe7a16ae4372b36b6d5547bbe380e51b57691fd0189ce36ae6a95dcf87"
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