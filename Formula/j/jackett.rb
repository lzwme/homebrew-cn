class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.327.tar.gz"
  sha256 "1f1662cb83f7dbf7e6421a21145c6ba20f96bf4257d57acd791333b33bbf024c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a725ba485790533bdf68b2774b16267e628e3d9247ec8ead45d13aa287dab73"
    sha256 cellar: :any,                 arm64_sequoia: "034f58106b8546c63ffa8d09e8bb82a337f25461c5f8f232fb4faf96b9096989"
    sha256 cellar: :any,                 arm64_sonoma:  "bb98c572b550040c89e948e2c39a34a16a973576318f10212771cf97fdf505ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "def5ab6ff81300b8ee9bba2e17c732486b848704ceead3128eb1d04df704a4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd65a961462e75dd983cc6f70ff490041263ad3110d2b1df9e23ab3fc0fda205"
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