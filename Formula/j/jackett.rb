class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2541.tar.gz"
  sha256 "5a3797da34cb5679c1b0fa0ce23e8f2b67fdcf956cf206f3b68a3771289255a6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c5baddf245728b52be75b0974b4c316f23de114f91907acb04d7deab3ae43926"
    sha256 cellar: :any, arm64_sequoia: "5128906cb3ffd368419ba4a07cacc950e8ac77b3fd345d125d057b4b92468809"
    sha256 cellar: :any, arm64_sonoma:  "d3acc65099e78c7c5a09d5bf9fd419573148072e695f6e4f5383c6d8785f0e50"
    sha256 cellar: :any, arm64_linux:   "73320468b5f13edb2eba7b298536d2edb0318dad32ca2406f48d03649e990941"
    sha256 cellar: :any, x86_64_linux:  "1fceef6a072ee0ce9dd965b20b6ee473bc4ecd320c81cafd008bffd5bbd6d633"
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