class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.394.tar.gz"
  sha256 "13a52642570aa2ad347b052566db18b7eaa120c4edd912919b8fe1fc16e31e04"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4513815adec310f3f10393027c2cf80541f4041ef23cabcee94962d40617aaa7"
    sha256 cellar: :any,                 arm64_sequoia: "8c6c1db25ad8c412544208f655797231d2632fffad667f29c7e9a49538426628"
    sha256 cellar: :any,                 arm64_sonoma:  "fd2dc2bc9e0b366b2a7ef4e416886b16c33c7f585fdfd56e2f1c04e8f786a035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "418732c48006672ec6c88ae9aec5ecea41005b2a8bcd566236f97651d5cb5ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26fda54200253d9cddd4efad0532ee6bf3e9c35326a0031068c62a0c9ff2b29c"
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