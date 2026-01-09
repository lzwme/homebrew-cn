class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.766.tar.gz"
  sha256 "73d750669604f75631b66fa5f42bb1ee54ad080f3a698226d7e4533289c9fb03"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "434563e995a3245bd58cadb63e7a70caee7640ee79ae2e8a8522830c354b9b81"
    sha256 cellar: :any,                 arm64_sequoia: "5c2cc99a43d153311a6cc3262a0ca42b005e1e002280695b92992220ed1470e0"
    sha256 cellar: :any,                 arm64_sonoma:  "8eed6ea64b6dd4d42b1f899505d1d72717cf9f8aeb2ff49041b8669584b90329"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b51f2fc46d390a0964229447aa52239a4242b29e87bec942b9cc64ce1382341e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b80077e061cb156fff7be7321f87a6b63310cc50540115a16f9d39df9b27de77"
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