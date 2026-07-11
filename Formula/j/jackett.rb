class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2200.tar.gz"
  sha256 "41864b9cd915e161bb5a6676e124cc9802d84cf8266a6cb6bbc9db483cfcc54d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3a8e9d3a69d250a7645f32a3acd933666c32f0c27b9c52ca9e73a50e56347acb"
    sha256 cellar: :any, arm64_sequoia: "ecf3c6f7f034b5b0497b9c5eae8670a3b639e3368cffe6159c75ff7ab8c1bf08"
    sha256 cellar: :any, arm64_sonoma:  "f2ab1f7c89815f72e472fde5338faf6d5e48df1b9dd416793fc43fc385840300"
    sha256 cellar: :any, sonoma:        "cdfc578c9367b43378822ed053523056f9a67b77db93791072e4d5419160074f"
    sha256 cellar: :any, arm64_linux:   "cd24ffefe3bfd8f33bd2fa2262b9a908e2f7df8c617f9a023ad71ff6fc59c77c"
    sha256 cellar: :any, x86_64_linux:  "483e03b229e617f45d138a3d342fc18eab6141cd2cccb5a70a504cc13dc0f73e"
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