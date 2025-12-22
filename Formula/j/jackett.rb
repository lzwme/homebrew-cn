class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.498.tar.gz"
  sha256 "9038e5913ceccbfe62652b7d73a33a5d47ed6fcd8e2af136d212b5e7f02bfb89"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "500eb086a26ad213b38653253140c489118db7709f25d14ce7602e8eeb001767"
    sha256 cellar: :any,                 arm64_sequoia: "bd654dc4464faab68cddc4997d7c94bda3b13512a1945b28839b2963c4776c43"
    sha256 cellar: :any,                 arm64_sonoma:  "f9561643d1a25e43390d0578ea95fbbf2188c635548f031e831245167682feef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68e046519ab4ee3f41c7a41384d22aa284a728169c854b55a57a0861d5018000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd3c2c879c1bd25d35fb17329c8e2b7ce9ab9aeac1602cf311031b8a9bc879b3"
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