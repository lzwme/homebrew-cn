class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.821.tar.gz"
  sha256 "681e5166482932f1acd06b4c8f7f2af6741b02edce26c8648ef02dc04f5eb3fe"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7198c619aed13a4565ac17558477f2feaebfc9f44c6886b59e99ec140c8aa5ce"
    sha256 cellar: :any,                 arm64_sequoia: "f35da35c40564c0801c0101623ed090e27b131456e90d2028b38b8fbaa845632"
    sha256 cellar: :any,                 arm64_sonoma:  "bd443b31904af09a7351430fde139ab5f2cc6d2f7cba325cdb6b0fa8c8fdd365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28a3e23a8777b52b96a09ee0ce655017ea93abdb67fce2278ceb8704da859d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31887ed17f51114f898933fe31ec0b7a5ef2612b2f2503a8d70ff0118da19407"
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