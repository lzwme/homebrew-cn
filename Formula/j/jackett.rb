class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.306.tar.gz"
  sha256 "c17536780955a0bf11d0e8ec577e2c9ada9f09ec4464333f7a6e8ba0c238777d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8aaabbf3fcd1ca2b3768e15915a46cd07be637de7a06f332273dcd3296fbb581"
    sha256 cellar: :any,                 arm64_sequoia: "9480be0ed4619151f88ddd768e70959ccc59fbfb3a31ac211dde3281ebabd28e"
    sha256 cellar: :any,                 arm64_sonoma:  "10afcc6b1bfbbae1e11681b0ec63ee48e1d6a45e95b0688e43c5f19ee54cf884"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d4172aee0d9218c07e0df348a7472fcb8c0418ec5f4c4fa07cd8857235d410f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bae89351e4305ff4bf54272120e549361ced0675caeccbdc803be0af8a38dd2"
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