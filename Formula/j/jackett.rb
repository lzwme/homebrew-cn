class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.252.tar.gz"
  sha256 "529b84986604d8aae7155c4193f5562394afaf94efa99f3144b57f1853d87be3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "592e9d46d11cc5418794f43b6f85a495e900f4d1e8a7ffbba1d60aa4d531c847"
    sha256 cellar: :any,                 arm64_sequoia: "31c81d68ee2bc9ee755a3c0a667b0361cb6d56fefd8037ff2f182d418a8f4b83"
    sha256 cellar: :any,                 arm64_sonoma:  "fcc2aa6a76dc51463d6a0c560d303e796a9a70f185fd55be50923caa17250c07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9727e46fbb9b4ab898efa0fadb679079456d390eb8b607285f37a463701bcccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10aaa01de5f8a7dcfb50d03d8d5db8c22b2b5cd1f226a570b6e5adb971718d0c"
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