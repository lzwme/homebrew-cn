class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2067.tar.gz"
  sha256 "509563c0e381107bb716d03809c0df92a6a906d08618f4484b77462bf59b9dc1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "25c7360ab787ed80de1ba9d60f2e5eada278e325219b7dc53bf06a3819a5e555"
    sha256 cellar: :any, arm64_sequoia: "40bc69ac45984aaa4b95632026ba2825176d263ebafdb846ad31f0b4918741d9"
    sha256 cellar: :any, arm64_sonoma:  "acdab949896826f9326ac0aa9cbaeee19709ffdc8839cbd026f0084ec0ae11d1"
    sha256 cellar: :any, sonoma:        "763a5e3ec0c7aefb1298dae8fc4f5f6a29552e83c331c9fb5a592f26ffb43746"
    sha256 cellar: :any, arm64_linux:   "89a30f41ceee43be14118954165b3211c9090c4e9807ded91e6705018c7bb934"
    sha256 cellar: :any, x86_64_linux:  "7a2c6692b291e3e7f97c69cc1920aa7bcab1d6d58c0a528ebe8d4b2a91e9e2ea"
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