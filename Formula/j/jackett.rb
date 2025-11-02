class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.241.tar.gz"
  sha256 "b328cf992066e431145ff448a9c946b1b5e3239f4bfd3ad3a73d3cacaaa35179"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96ca4bae2c338335391ba564c38b264367c3993746098eb2d0c678a302ecc70a"
    sha256 cellar: :any,                 arm64_sequoia: "29d6bd180b6d672a28140ae400c52c25433a9f515f0b770e9767a88f9ccbc957"
    sha256 cellar: :any,                 arm64_sonoma:  "b2c8dbc37a2f1633efde8fb3c6ecb0eab205497a47b2833c1ef9e6fdb9465783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37705f77b128b318407ce47409011bf51d90789a49a0272d41848f57cf73dc4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620c5562b67669255de23b4be8f7523fbc62ffac7ff1c00aa99d225ef563d808"
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