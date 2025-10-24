class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.175.tar.gz"
  sha256 "25624c6863dd228e83beef6d2489a4501d30c3fa88c3e0651b192b5113a3b1b7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9789443cb0cdbb9d4e41409ec83cabe5db504bb0b3cf9931637767210818c50f"
    sha256 cellar: :any,                 arm64_sequoia: "1319a71877d0f23af3116d5291a16901489d96e5456ea83fb5012630f169df28"
    sha256 cellar: :any,                 arm64_sonoma:  "5feb2cd95b899391cb1997c8952a447a62e15889e76c365e2f45052778fa20b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a711665d4dbcc52f21c11a85f12815801d4cb66d6ad6a263000015cb52f52f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1fd1000e6e171713df796f0334e020b6cd72cf870ce74ce2062c35bc51e1ad"
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