class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.179.tar.gz"
  sha256 "18550e46a1e65be5562d1956489756265796b85e8beb2f10518f1fca85d5c195"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "522a47a2ef448ac6fb67b20583c08ec7952f0ba04c650b8b1a31fd7e9bcd2cf9"
    sha256 cellar: :any,                 arm64_sequoia: "9f0a8fc2299804f5e36e24d6afee6087ff0cd12a426331c1968c66ba0dbe77ce"
    sha256 cellar: :any,                 arm64_sonoma:  "f9b7022079a15d5170d44a33e356858fefeddcd1d9976cfa8d8ebba17e7589cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9cc003991fc395a3bab56593cc59ad48b5bf442fcf7b79b9d596fbc4f0bed8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8691b75288b68a1ae4f7e9ec377221686f671f7666a8a7eeab556094b5e353a1"
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