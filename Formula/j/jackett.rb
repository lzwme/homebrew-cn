class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.28.tar.gz"
  sha256 "8cde7255b3baa83bf9dedc63544c78923260c999a0d476c854d054e9a371e547"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5716a7d89a2261ca065fbbf79b7e1fe4de701e90847d30648d32719a42daa085"
    sha256 cellar: :any,                 arm64_sequoia: "9134275e42a06627ca4708d92d5eff1694a0ba9dd6705ae736b5cc0a4c5637ab"
    sha256 cellar: :any,                 arm64_sonoma:  "bbd7ec0384b9c5dff20c3db2cc4b08c64188ee589fb3bb9a874f08ee0498bc5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be1fc47b255a32839778a5a7699e6cc41348a8eb8fbfffd6b798537d5b1c1985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d9df7fa3bf56df21f7502337d8bcf5a0b5f76b2b77cdceb45fd9f26be393967"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

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

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end