class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.111.tar.gz"
  sha256 "437168739fd1a291aaa1d1f8c52fcb29c0d59f94e4fc349db0846854c8784138"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "28a523da4893d0550ab090b1cc7241cdc84eaae65b031828aa4160b32719b8b3"
    sha256 cellar: :any,                 arm64_sequoia: "5cc811201e8250ace30116a7b49bcc7836908987d8f169359209c19031045f52"
    sha256 cellar: :any,                 arm64_sonoma:  "541324ea3dda40c13d6ee11070e334743ed55dda4fb1aeddcd330f897beeeb60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55fe11d8ba03fb48f7e7831089d1fe8128f21fcdc8451b91d6530ce8ba4b8a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64ca50af2737cbb24f43b3aa65d7a8731edcad6a86a0fbb96d321657ed7e9d92"
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