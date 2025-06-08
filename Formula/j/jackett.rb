class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1997.tar.gz"
  sha256 "24f8d9acc040ef783417040f9bf9d534eac5a878a3ad57c999f0288fbb33ab72"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a547966f7467a9d81fc821a6bef76f93a89421e4ad04ccdf641fb84d760e12f3"
    sha256 cellar: :any,                 arm64_sonoma:  "9bd459f9d72e04449f29ef636928926ab3b73ac1235cb31e3a78eabc0fc9734d"
    sha256 cellar: :any,                 arm64_ventura: "b98beb12b1540a5e3f72f4502638681345f96ed22402dbfb6ae665aa38510d55"
    sha256 cellar: :any,                 ventura:       "819d08901856e4d1c5a1c7ea1b758e800c91a956570b34f7630058875d950620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a35080772338cb910e5dd03a6ee7e6a20db7d9905116781d8c6e1793a5f8e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d5ca1fd5444288ee010b4762c43c4063f0cf423eab7ada87cd400963a7618a"
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