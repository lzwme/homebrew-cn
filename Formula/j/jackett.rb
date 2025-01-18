class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1275.tar.gz"
  sha256 "31f434fe84d43b036a9a4711c4cd880a79d65d149b65d67fe8e1d51be04e32f3"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "385e78df27da8043d3fe6acc3baf315eb98196a5397ab7f1656a80b10c3a573c"
    sha256 cellar: :any,                 arm64_sonoma:  "ba9b5cc8488cb4df9fc93602649619e523ed371d1ae52aec5b6c8b1a451c254a"
    sha256 cellar: :any,                 arm64_ventura: "6f45e56c0ffde58fe7dcc7a671c64908dac81f4473b0c6d82f2508757c52dc3f"
    sha256 cellar: :any,                 ventura:       "d30147a07dde3c15f67c2f67579cf76628fb62ee1512d5c2db2663c182c8c469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b335aa991e4d81e92cc836399168acaf32ab3fa72f6d596f51cbb5647a9ea37"
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