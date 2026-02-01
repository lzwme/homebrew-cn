class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.993.tar.gz"
  sha256 "a71876517b116a92657794f37cfcd730d5693e746156e4e2dd202abde3832305"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "910fa0a8094ed8b4d01cd9d2c8c955fb23409bb90b04191a28003fd8ef1d221d"
    sha256 cellar: :any,                 arm64_sequoia: "196f14558f34657de8e7a10a6b581863e065e5ac39e7305bd149b55cb0bfd506"
    sha256 cellar: :any,                 arm64_sonoma:  "aebba958cf98a2cf0f6094bddc8ffce4967d5aa2752f6a2de09881eb6daf6d86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b0de23720b0d525ddaf36a3614517661fd02556238f8b96614703a353c80c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b08ce5f007f7f20aa5662c06df47b1ccdd6e5405a1886618cfc98911ad6ebf0a"
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