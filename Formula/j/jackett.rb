class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.445.tar.gz"
  sha256 "4ac312ff2bcb349e1ccf6fa558d1beca5812a617d64c5786b2092aad01a9c879"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46ee34587606579dda569801041b962ff279c6dfdacc656fd839fbc87924501a"
    sha256 cellar: :any,                 arm64_sequoia: "3ec2f0ea6e2d751741571de79f950d670eb9fc5847ff923794807444d94fd6b9"
    sha256 cellar: :any,                 arm64_sonoma:  "ab3bcc704fcc427076ca120b00d4eb1a6813b18c05f65542ccac42632e4884bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "408af025d493407b0303ff7846dfd621474b36fa258c307123d185cff9570812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426a5d7560aab451c7530ef028f623a34bbba374e6f602e4c51d03af99a1325c"
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