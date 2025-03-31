class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1709.tar.gz"
  sha256 "109db2c71216ebc7a2d65e971e004c5009579018e9e96de6d43c2f26a57a77a5"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90585b053d7f214a76f89c7d56d321c6b4317c3eb0705d19b0ef24e881ddbc05"
    sha256 cellar: :any,                 arm64_sonoma:  "804b0a2cf90d6e0bdc03f00425b37149699fa08e9f65365d22fe558776bc6446"
    sha256 cellar: :any,                 arm64_ventura: "f563b10b921e1adb11ad263630728ffd468d8dfbca95fdb53a43bf0d01fe026b"
    sha256 cellar: :any,                 ventura:       "4b8d7013bc057963bec068896303cadc6e10f87e1c81d2731fbe72da841c3701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbd67e936a6843939129ebf2a73dc7ff959f4a5749970a43d862c284fa65b859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7004ad616633380eac45460490c6f89729172422398902d9b7b887ff40d27841"
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