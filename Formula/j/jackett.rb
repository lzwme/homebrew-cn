class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2311.tar.gz"
  sha256 "297d545520d032f4ddafc91be7639f22a1ec413f614e54865b8ebc3a30f4b761"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a7791b56ac29b2fdace5e9a6cd990bbc4a975725efdc8eda40f1368fb15bb6f"
    sha256 cellar: :any,                 arm64_sonoma:  "a96d5c55ff372acd423f7ede1f322987ce8a2ae9fde643c0c85ab08af1e2d3b0"
    sha256 cellar: :any,                 arm64_ventura: "576cda49120c8be1537c59758b69dec8779817b73bbe1699208b46f4c4e162f4"
    sha256 cellar: :any,                 ventura:       "4bd4a595dbf8c96fa0b281e28b25b6894f11408c64b2b8dad379b2391dc94e3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3bcd77881208da2863198505d5344c89be64ee790f5babcd675d579b706d097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b04c0ff9a19ec4bddb5017ea3cd5f96ae95a1b774ba8b32491c521aa10840f7"
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