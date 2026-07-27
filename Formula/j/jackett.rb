class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2268.tar.gz"
  sha256 "86a7aaf0d43b3852ec607a1e1ac382f4d776b2d8b3ae096acccdab2ecfb2c202"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ead8126cd37135d1c0ee0ff6c336d4227f56d03cc2ec0e1265feca34e35baa8c"
    sha256 cellar: :any, arm64_sequoia: "a478cd337f7cf23ecc40f9790b4970819db52c428de2b401e3a4a00ee9f31aa6"
    sha256 cellar: :any, arm64_sonoma:  "ba05b1aeada12ab23a8765c48be27682e52f676c3da014d294694553b4d1e47c"
    sha256 cellar: :any, sonoma:        "f58a3f800dd158af2d3b881ef21696aedfd7962c40d42ca1f7d413f9eb80d3cb"
    sha256 cellar: :any, arm64_linux:   "ee481d7d0cfcca94edb09a3954f52494c2bc601154561052dbe8f9062e33853a"
    sha256 cellar: :any, x86_64_linux:  "900ec30ef54eacf1677aa0f9ad7deac96300cb0a8f18d0f841b795b23f4bee0e"
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