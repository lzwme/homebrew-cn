class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.250.tar.gz"
  sha256 "7560ffa07bebb17db1f1576f5531f62b843f46ae36cae1dc79e3220c3c1b9c72"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f1bd04165cae676e30407429eb87a0a8e384c06bf739b5010b69ed302a0b15f"
    sha256 cellar: :any,                 arm64_sequoia: "0e67dfa48e60213d03886e9a2105ae450b4b68d9cd138edf13c8f14a2d626057"
    sha256 cellar: :any,                 arm64_sonoma:  "df7a98dd7a49791da692e0535c6c79028743ced52b7ac8ea9a9e3ec379fd3dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b71988567a163efa778226993c5161f0d2891f7a9a9ba0d8b8907dbe71b0d9ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1cff9af3430691684495c25dc876221e5cb36075999cd0b6784b9decae8f18e"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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