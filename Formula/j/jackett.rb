class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1867.tar.gz"
  sha256 "c0310b753ae1b6fb09719311575540dd130fc1a96f3761012c7d3eafd9354e1c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4297d3bebef28c4e6c459260f6af9bfd21da7eb920bfcdd7da32adb2a88da446"
    sha256 cellar: :any,                 arm64_sequoia: "8e18029dfda178a76f902f5f99758b7313ac02e121572e2057073e27250bfd2e"
    sha256 cellar: :any,                 arm64_sonoma:  "804197fd2089d4c26f8036d76da1f4b6bc5ca55eea975696eb81b1b3b461e5c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e03baad9e072a063396700e090028a2f2aa173155873e93840df8d48daa8355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f1e0fc3dff966309712d5e38343dced26dd28c3e6d34e1b565bcdc3dd47b948"
  end

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