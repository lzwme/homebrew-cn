class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1191.tar.gz"
  sha256 "b7a1e46ee6d63fb0e095210420c967a1ce1b9e250a1b987817fa0d12ec41db58"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b3fc06dfe05528721d61da8b15149ed30aa1355ac048fdcf3393ddef33742c8"
    sha256 cellar: :any,                 arm64_sonoma:  "b10863ca2183ca3022da9910ee6d9a98574a21bd353c53a469abd06c87d72fe1"
    sha256 cellar: :any,                 arm64_ventura: "13f1ad383d1a3434ac9d1a0c48e0440cae518b592298e199280df3bbf767e160"
    sha256 cellar: :any,                 ventura:       "0d9450d451b4dc28766a807443387ee72581a6210fab37d8ff439a5ef97517fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e8c80230a2cbe8128c748a8d036ad035da89822f277aef3bed8079778d51f98"
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