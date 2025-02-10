class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1391.tar.gz"
  sha256 "9accc0ba1b1d2548b04d340664f3a72b722e891958108f822af03768c7afb779"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0e5de102ac0aff8e207e8dd493630d119ad94518b151a1bcfbc4f68400b16e28"
    sha256 cellar: :any,                 arm64_sonoma:  "7f1536d143ebf8c99622b4eb374c45d7ed7dfccb9cb8445ab0a611acd2c46ed4"
    sha256 cellar: :any,                 arm64_ventura: "da360e4a1b47ba7e8ac0ec4d509d6787901eea7ea1b2c26847e9ffca9c6402a6"
    sha256 cellar: :any,                 ventura:       "bc7daa7e9e5b94e34e1615e4eaf67000df07c3d9df4d6a0a3479c71bae60658e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57ce95770833a51c3c1b3260f192c590dd2e2a5e69a1aa2d2d8ea733d32ef425"
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