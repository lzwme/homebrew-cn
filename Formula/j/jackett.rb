class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1381.tar.gz"
  sha256 "35a83139a0a10b0e9775ba88f43d26b75c69ced29c3a4fa3d0edfebd355a27c3"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4a8cf341f02ae5d892416a8193eb4bf182179ea4fde6467aaaac594e9d98b57e"
    sha256 cellar: :any,                 arm64_sonoma:  "c7cdc67bc0249797f75969ff7e9af776341af90417024f2f2313c77f7417f057"
    sha256 cellar: :any,                 arm64_ventura: "14b5d58a8a72336301f1721e0ee13cf5b602ca1ba7c663fb88ef0565ab25661d"
    sha256 cellar: :any,                 ventura:       "310dee5399e80704a41aec46c691ff0206ed9867f7660526612387387171cae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f09e46acfdc6125f8bd4166f5e931697c259fb7d4371f59685345e24cf20195"
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