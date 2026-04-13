class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1567.tar.gz"
  sha256 "5b685844204e8df7f4391471d4fedc643341a9f36d5e3b2c1b56b4d08f501c5d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "419e48091c2d5b91e38facc0ba48491093914854532bb85602d102cdba3f9c7a"
    sha256 cellar: :any,                 arm64_sequoia: "ba034202b9bf24b1a9b00c9a85796b409ea28b31a8a8eb556c7859c44f488536"
    sha256 cellar: :any,                 arm64_sonoma:  "46ec6c0a06402d248e1300fb6a8ecf6c2ca87c7419e5d43e3894e4c0d88d1c65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "580895a6c0a991621ec678f19b167e6c384ad210b014bfcd1550bb010a29281f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61a07d45015d3038a3b59660bc332f24345c6678a9e753495e85ccf9cb39d7e9"
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