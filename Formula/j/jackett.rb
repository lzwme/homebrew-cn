class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.72.tar.gz"
  sha256 "4505944c206fd4b63b077a4875e79d6b990b64248bea094f89ae1fe4532f32a2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c2ccb27c90b832e40b6f56dbb3cf5da883a6549c8f98740cd8659a13eea71b1"
    sha256 cellar: :any,                 arm64_sequoia: "f35d11cb149ee2a3c62b57c092e8f95e61c546e3504b8d061c1a86a79c92216d"
    sha256 cellar: :any,                 arm64_sonoma:  "818c76e3db8ba0203e7941aa627987ea50a3b4c12183bb5a0b9ef278b03c9ba8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c4ec11e3760d27db5b62531066ecf7f7d5c016e793890790777e6f4ba383da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee033a9583a2dc985fdd3fd1af839624cd96bea45ac93a61e99fc02c1fa44ddb"
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