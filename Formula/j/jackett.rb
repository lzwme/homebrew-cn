class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2297.tar.gz"
  sha256 "5e841ce94fb4db656fcf417a39b6ce2d608641f0f338d215a8b2ccedb827666b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d3daa9b082c932ddf8dbf9d1294f0267e3ec0b54ab718dd99facdc564036a026"
    sha256 cellar: :any, arm64_sequoia: "fe694564c81bbd2a706b6ee4ec25652525593695424d293963b77518008a8359"
    sha256 cellar: :any, arm64_sonoma:  "913e314c2b050cc95277b212ef6707f9d09694004ed9a9c8761f23981266ed6a"
    sha256 cellar: :any, sonoma:        "fca22a811fad39839f4bbc9dfc6f3e6fca60b8de14e74d7a0b0e1c8752ad4abe"
    sha256 cellar: :any, arm64_linux:   "f3224602e38db80c8bd4e6bbaa93d636d06698bc86b32e140f367e284f146586"
    sha256 cellar: :any, x86_64_linux:  "58314e0e7dc8bd3ea2331d5e3ebf7388cb33e846659f210ec8bb204f1201219c"
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