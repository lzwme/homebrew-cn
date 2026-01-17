class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.863.tar.gz"
  sha256 "e073224023cb5e86bbdfb4a3c622fdf025190e4fd6f12f475c3e2f1f9dcb15fa"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97b6ec1da5e98b5979d07c885143447e14664ebc5b5d812a8316dd19ede279f1"
    sha256 cellar: :any,                 arm64_sequoia: "f56afa092098324678401646b18e3f6b0ab5b6a4c14e22a60767c709698a6f49"
    sha256 cellar: :any,                 arm64_sonoma:  "ddb6dea710b82b4a8ef74aa7fb1805efff2d7d4bad2d4f1073da398ebf7f9d1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cb990e44db993875aec23721db386ce940bc2e730d1fdb7b54f3e4e581259f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06173da429140c33b44d9f0930e9943912acf514432dd5900783506569455698"
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