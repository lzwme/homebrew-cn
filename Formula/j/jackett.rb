class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.90.tar.gz"
  sha256 "44b9dd35f111a9c02be479cf8eb107b3d62ace470eecca586c8ca9aecfa52a80"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "138017450be2c5d13b9deae2b7bdabe484cc2cc87d3b5e4961072dd8e3a4d9ee"
    sha256 cellar: :any,                 arm64_sequoia: "2331a359bdb04ff24d4e83823fa79a6794a25916878b5cddcff4c43c5cb9c850"
    sha256 cellar: :any,                 arm64_sonoma:  "90bc64767e307c8b1950723dbe60ce582bcad40759c56c6f6aff796b0b4a67d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68fe204b295f06e99af27c5c33b49618c1b03397f02b0febd5400f256bf8420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace037d7c966d251e3d8dca839610a85b072f2050be8a6806d17cee2997e9371"
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