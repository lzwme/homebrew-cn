class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1455.tar.gz"
  sha256 "77030be9ab6e6523467fdcafc910f0e6203a3154ea44f9fbe21213f0c43f703c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7ecc9a8e489923bea72b814ba336fd6e1972471af99c28f5de2b3b9c47142d17"
    sha256 cellar: :any,                 arm64_sonoma:  "92bec28c2096204bbc05b1153123ec245904f443905000fda2bd53190f89f730"
    sha256 cellar: :any,                 arm64_ventura: "4b2612065a4dc4360e1c4127720a686e4ea5ea2c3e37c287ca2e62a432bb7564"
    sha256 cellar: :any,                 ventura:       "e25b980b737f25e2a31f3a76266e5a4d872d62094effe88903b580f9ec39e9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e8844d37fc4f752d7d6f6f9c1f4e07ed1aaed1635ca6c57236a12a64060e9c0"
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end