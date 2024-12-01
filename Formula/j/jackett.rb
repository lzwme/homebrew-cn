class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1021.tar.gz"
  sha256 "d5467c5e64ce480d9ba7a681eb01464771d4cdbf281ffd2fc7a1449f249ca448"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "23ce736dcc52aaa96b904e5b1c686d061fe51936fa780c90ee663efee8f9b2d0"
    sha256 cellar: :any,                 arm64_sonoma:  "819f3807644b668d8d4c710bfaa079f60d8c959177dbbc76655ab481af848da4"
    sha256 cellar: :any,                 arm64_ventura: "93a611f9c199d8d76df91fc1834a9d785675b22bb4b3bcaa4a47892bd3f4a879"
    sha256 cellar: :any,                 ventura:       "fd4a011fb77644676c408fb1c967e71d8043227de65e2ba155d6b0c2c64b0100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55dec9a942a61319acf595bf55ff056d79b182f42bfb01806d0be29506ec3948"
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