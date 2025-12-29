class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.590.tar.gz"
  sha256 "0ff9f6e0422030483657cea8d31bf2084e4d1f7f3b11abfb3b5f9490f4dcd231"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2abee9a822257cb65ee339cc0ae5f186e62e5a238a8bb097b60828025c828ff7"
    sha256 cellar: :any,                 arm64_sequoia: "fb85566ec925c352219abfdb0f2e027a4e8aa19ce909f43f68b5f632040dda50"
    sha256 cellar: :any,                 arm64_sonoma:  "d6d6892b58f6b82fd556eb3ca87d5fb9d2ec4e31302374c0ba6582fa8d16f5e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d93be87f89017c5f5e656a57bc4b433b50c317472e86d0207f2b79b9abf97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b4f7a3ddaccc8807e2615fcdaf153f561b73af4aff1574c0820093618d32498"
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