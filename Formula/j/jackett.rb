class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2411.tar.gz"
  sha256 "d488bc7247b793b227a5560255acbafdaae8d2f68c5f854f453e5da56fabed9b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97bc9f4a783cf2bc82a21e30179084957d06813729af79031cfc8a476425ad54"
    sha256 cellar: :any,                 arm64_sonoma:  "a53b8e5575a16de326f3a084b8ce62ccc9765f9882ae10ddf53831886311deff"
    sha256 cellar: :any,                 arm64_ventura: "84f2dd1fd3b2ebb4c55e1fbab0c06eb89df2c7359b29b1ab85e23077a5add42b"
    sha256 cellar: :any,                 ventura:       "34fd64eb5b97b81b2e6c7a9ee28b19454c42ea2078cf22bd77777bad06d9a13f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b00f2a0ed2dd15cec25056d5c35cfb04082ccb3c2d46e17fed098e8a58f90a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43ad6cbc440530dd6e5619da6b60a63c21f78fef3c2822b861413208b716a3b4"
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