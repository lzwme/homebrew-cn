class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1341.tar.gz"
  sha256 "f00d58c78fe217bd7e1114cbab3e353f2a612253a3918e7e07475e47c3b42451"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2903114c4477ad7c52d01d6ed5d19fe65ff6957704ed999ed9f77b2a8c1649e3"
    sha256 cellar: :any,                 arm64_sequoia: "bb6fe133baadd9b3ad6c2f1de88dde69a4f27c5a5652bacd86d6bb447c593e67"
    sha256 cellar: :any,                 arm64_sonoma:  "f75511f1b2124ec0da1aab4f7472fce1b06407c71e1d6b15111623d52f90ed2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed550c421bd118dbe9f295536dc1710b3deee7211fa15cc191c57e97a13b9146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "346fd7df5e875189290e726fbee033494180a3ae5d55dc700216dc5ca45e5483"
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