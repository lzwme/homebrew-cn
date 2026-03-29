class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1474.tar.gz"
  sha256 "9261cc5eb7066403bb8c942c4a1b4b4ef6650edf94d6c5ededb1c51e51272ffd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b74de64bb5e08ef61564af1e165595025c3992b9529176e165afafe95f97611"
    sha256 cellar: :any,                 arm64_sequoia: "80381b56bda92c26c2462adf1f26f01166e7b09c68f711f3ee5f6efcb7bc890a"
    sha256 cellar: :any,                 arm64_sonoma:  "901eca556069f3932e4041c596eebd3939aef8bac2fce19767e5920507003e56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2eab4f2d937fdfc6889c86a1083990bfb194fe52215a4312f97d49e7c962daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba30185161315c250d9f14eb8ee6c8bdeb94877b70a248fe8f697397342c430"
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