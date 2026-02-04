class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1019.tar.gz"
  sha256 "2736dc155371726fa308711aacf012f5025cb260cca2428e13264978136eeeea"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e55477e8fb9c6192f5a52a7c414caa8d0c5f7ad8377a786fc0b98bcd4c209eb"
    sha256 cellar: :any,                 arm64_sequoia: "0becb0c1464557f9fd1f7f289d38f838bf308d9d132ccf211a86ca9792d7af36"
    sha256 cellar: :any,                 arm64_sonoma:  "1b10970cce7b33cb92e3c2e4b28f59acf33792101c18e53dfe29ee182409132a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "605f1785b6b3a5e4a2248f5e04686fdfd27142e9d31756fe3ab4e25ac5ba508c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a697dbb59383125534eec3092fc1d4d8a544eace50bba54c0417b5d29bfc037"
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