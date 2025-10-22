class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.166.tar.gz"
  sha256 "844b55b996a5fc65abc220adc4b57a27b31a9273431700e6eab600eb30939377"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09056be5531e0a931e690f12ecf125ee7193b7e5eac7d57d4bf220308ff855cf"
    sha256 cellar: :any,                 arm64_sequoia: "3fe09f6616e2675d92b47d335c3c347a073a576d98ae6e624162d827a3420f7d"
    sha256 cellar: :any,                 arm64_sonoma:  "63842da3c336cf0365f2d30a693100e210613e2e92d598eed8145099820c5d96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "196d00666d3801dd08b4c3fce679dc946fc33a8e39ba98f014034d4f0cb351f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ddbe717f29b246a0b22678b3d014ff80966bfb3dadb3ace5c1306ee94fe7824"
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