class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1079.tar.gz"
  sha256 "61306b166ef3315b564d627df79360628f59a69521b331785119bb039f3a2e9b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47837d8ad99c78cef55b93ef24c67d1342ec430df9cb9f8fe5fbe8e1a13b266d"
    sha256 cellar: :any,                 arm64_sonoma:  "db9a5748f42d2bf5c1551b09631b0a349dcdcdd3dc57cec0de8163aa4ff7836b"
    sha256 cellar: :any,                 arm64_ventura: "ddafdac8d1de5e6b5757c7dc39484a142bafa13a1346f49a76bf3fea65e495fd"
    sha256 cellar: :any,                 ventura:       "bdd36181fa837ac6342407346ba2c93824cf66376147e02472245fbdc4942a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390a442e4d42ecae1619b512c7b685d1ef049ca3bc80f41a3b1ff415a6f3cc07"
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