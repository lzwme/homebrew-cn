class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2219.tar.gz"
  sha256 "f2b3413fe7adfd24a87c3b5f624e6f40789a779bd1a79a422769baac8223d3da"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a63ca2047ff90d03fdf3f2930757f8be1a9e638109b2579ad50e409f00604408"
    sha256 cellar: :any, arm64_sequoia: "e47a7d9847bba2c726be9142fb39590eb3f83ff28444c0720e411eb3849999ec"
    sha256 cellar: :any, arm64_sonoma:  "a36cf61d7b670da8847e8942022e5c83539bbc93a1d8609bbcb65d192d339ca2"
    sha256 cellar: :any, sonoma:        "92d68410be2fda3ae10e780344bd95bd16c94280c6333107cd0042da8c6119cf"
    sha256 cellar: :any, arm64_linux:   "829e0c3d1370749a0a403ebdc0dada8e6dac9a0ea87c8552f8b312024b58da9e"
    sha256 cellar: :any, x86_64_linux:  "a3a8d2b76ff44fd12065ff8992c3fa5879603b1a8ece4284d0c86a29278e4a3b"
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