class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.159.tar.gz"
  sha256 "f59648139ff094f3235f786619b4ba838c740ebaba5f162568d84db31ded0da4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ef56c962d116e22f70b50aa2cc153cf3734edfa1191c7d5274e47c2ad585679"
    sha256 cellar: :any,                 arm64_sequoia: "f1601dcb4508d8dfdf4df8eb700a95f471dd41b1a1c8f1f44b25c2818cc2bdd7"
    sha256 cellar: :any,                 arm64_sonoma:  "88d7101ea119ae4cefe1a5a68a88adb0b3c380f8871b6dda2b29a0ce74545b45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4253f3981f7d294bbd92fee6f4264324c572cd0c0777e297044289f80c407c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c51d6011dbeb53e04a278afc82b6a4e7a63f3ca023fa900ca25ed4ea6b912b6"
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