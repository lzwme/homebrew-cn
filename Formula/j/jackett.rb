class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2292.tar.gz"
  sha256 "788a7e6043a8804b6197053ad62c7447e303931ea16c3b441235c96a4b91ded8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "158d551522e63832b37e5dfcdaffdeac8f8eec2bf95803250e8042f723cc4a74"
    sha256 cellar: :any, arm64_sequoia: "17feeb7bd89072e97dfca3cfa1ed8f556b57c38f759c2cc9c2e05a280226dad9"
    sha256 cellar: :any, arm64_sonoma:  "99a19e5163f52853fdfcdf7bf65c4f213346776bd33b7c655ac1870400a15bd0"
    sha256 cellar: :any, sonoma:        "a7b04c671c2077f2ec82a8fd6b80d169e7db81c2072de643c5555f65a885b0c7"
    sha256 cellar: :any, arm64_linux:   "7ab07daf6803324977cf31ab3ac1a7b770504b5519ce15c47991eb2e350b0643"
    sha256 cellar: :any, x86_64_linux:  "844c6af188945149678baa33873c56cad64c56f10ae30adb16420199b1a11edf"
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