class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1247.tar.gz"
  sha256 "e0dc3ed6a499f81cc179142019b360fa48cf6846d2b1184eadc55821ab3843e6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2c05c53de240542e1eb90fec6e9ae5c561426de9e966868104d38119f4d1107"
    sha256 cellar: :any,                 arm64_sequoia: "b94d2d7f30d49bfcd1c0c8d28dd3ab771aa3d30d9483bb391e2ae7283d5febc2"
    sha256 cellar: :any,                 arm64_sonoma:  "fff6d8d7e2302d8ab9cc985c0877a799d5f0cbe8b502d3734612ae1330306ab3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72a9f0ea9ff435ce493e9b18b71477d617ed8012232ea639df59b21098e4ce0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b775ace7821e2a358f80daa7cacf0c049defc2991c1168a4489ba00399a353"
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