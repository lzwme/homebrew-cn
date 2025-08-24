class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2325.tar.gz"
  sha256 "c161c3cf3bb645fa9ca4e70587f17f00a83e7ab622e651a85a3cca7f960f6b08"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "496868975fa195595a2376934539c7af5d22f1f01e86ce924f01fec69715282e"
    sha256 cellar: :any,                 arm64_sonoma:  "5d1c0736d4fc2bf638935bb06739ad714ca5faa2794525d94d03914171838788"
    sha256 cellar: :any,                 arm64_ventura: "1e39525925567160274d8d94d82008072b37025b937675af16a56fcff765a9dd"
    sha256 cellar: :any,                 ventura:       "0927d0bb77a6080d222bda1344cb5f6ad7f9c7e23a99f5f14d2e589bae9372e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f0759026ad14b01fdf0b9ec9f2d1dde259ae58820319fe8f22272379db5497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c990f3913965a47b1e737365e0f2033667f2e725fe243212d91422b6998832e"
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