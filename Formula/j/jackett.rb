class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1226.tar.gz"
  sha256 "11333acb04a2e937346a19bcd9637ff2bbc34bdfbe4b52c715cb5787f3f1f363"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74f47f83b1688339a2b2e5d231ba21d368c411fe0350cde124d59735229b4178"
    sha256 cellar: :any,                 arm64_sequoia: "ed7e26aee222decf1ce376d29c1d715aa0c50730e9c73617f81a9e98a600c084"
    sha256 cellar: :any,                 arm64_sonoma:  "8d139016ea51385a4263b42b42c0a605eb06e970cbd6e9fce8cdd89f64848947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51e003dc1797fd00896162479449970fab0f2d0491a5d8e68f3105519832d051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4cf96dee9b5c79506cf8230a299ac41647eaca51bb7140a86cfe9bcb3eaef90"
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