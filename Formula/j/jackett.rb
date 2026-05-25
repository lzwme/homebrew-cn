class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1926.tar.gz"
  sha256 "77151237ecd23c38de43517dad1763596103f028969df460f32e5928e2f7acf7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25c2c4d85d9740360a94dee1a90c06c45826a891dba0b1930ccc22b8c3d31410"
    sha256 cellar: :any,                 arm64_sequoia: "c8090f666b61d895e823552f74b6db7ea1e46cf6c64a835729f4866eb57a24ec"
    sha256 cellar: :any,                 arm64_sonoma:  "bccebbe235d52399cd4e24f0e6526bf9cc3c1e97f22fe89487cee615d9d3c6b2"
    sha256 cellar: :any,                 sonoma:        "e2c41580aee9e3dc0f15dc28abd2d7d0512e21fea4e3e704c7f9f87b7a270d6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e4b230528f9d2eec78aa80f38cf1f17119c3060228866c44be879f3fe7f0ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f9047ba12f0c59a492332f037d4470f5cc3a805d8281d752ce400c3dae0e3d"
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