class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2145.tar.gz"
  sha256 "5ed5ecdccb29b14a8642d819069dbec8842ff7d8b530952571ea0026bad93293"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d655bdf159ff134427595ea72994b9f42d0c63af46d9eabb404c4dcf2e990548"
    sha256 cellar: :any,                 arm64_sonoma:  "2733a98a718c89a64644dc810d55b32c91f9b5d1db34636f0503067295382cfc"
    sha256 cellar: :any,                 arm64_ventura: "bbc627674fd037d2c83bbf04fc40ddebdb5428757ad6bc63646b4a10aad9ce8c"
    sha256 cellar: :any,                 ventura:       "b146fb277acefd558e72a6f9d98f15a7bc1124e53ea278332bf69dadd552f324"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f0635bebda785be419bac148fa99bbc1d1143ed6609ee010cd212f7e098f390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e42963b83c3c5bd0278d5922dd17125222c3ccf3f70f414bed9e025eb43d9cc"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

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