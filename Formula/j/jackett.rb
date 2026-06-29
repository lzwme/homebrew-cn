class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2135.tar.gz"
  sha256 "d730814649f16cc5b7804914f47f4356ebb5ecd299c8c4d76f32ea0f8c6740f9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ce5b3480a32bae59cf80f2cee84bab7cc39b7c24cb111a22866eb4cf0cb2aebf"
    sha256 cellar: :any, arm64_sequoia: "957bd94dd2d80ad9373fc2e975fe8b6d7b7448de543467bbf7ca383a743adff8"
    sha256 cellar: :any, arm64_sonoma:  "848cc7ecdc855909c8d296b8e25860208fe08b6126ee38837bef3d22354417cd"
    sha256 cellar: :any, sonoma:        "b202ff50e147b20855b149b626f4136538f9de62d85a5d7c13ee6447c28f8e59"
    sha256 cellar: :any, arm64_linux:   "d77a69a75de247caeff0ac8f2b646653f01c914934f35b28538ea7b57732a7ed"
    sha256 cellar: :any, x86_64_linux:  "4d0a53212b3844ec59ed936c18ebeef9aac2fcf8bb6ae0c9dde3de8f37e996b3"
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