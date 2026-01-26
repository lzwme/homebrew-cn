class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.932.tar.gz"
  sha256 "29222c90e5dea353c23fcb44cacc1d2504be5cbd65266f8b1ea5bb93c362670e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d60292d864ecd9b6745c583cc69c11846f16d2d694b15b157dac1fa161f5a034"
    sha256 cellar: :any,                 arm64_sequoia: "fc800b5d1fcbb585d2dd5999d9b8a561c4ef22ff209bbd21dbb51a14825cd339"
    sha256 cellar: :any,                 arm64_sonoma:  "3b3b47d1d884e28010f8c47f7822069e3e8886eb23ad5f3a3e080865dcc24101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e44d24454cf2b9719967afe8bb0d8f46b87c3333828355805bab46cd651547de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf2da32b4a1680cd357293e8a3bf66bf51ac23ea612082e11c715360fbbea3a6"
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