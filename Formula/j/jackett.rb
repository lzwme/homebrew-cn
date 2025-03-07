class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1512.tar.gz"
  sha256 "0fb862b8848131283c737dd3293d430e91e1fd2ee8ba61381df4f1e619284dff"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9536f0a43f89f33ea6dc554cdc0c0cde0d6c86db726821678794193cad6fccae"
    sha256 cellar: :any,                 arm64_sonoma:  "263636b1cd560f6b13b7a72468827e72e36908230a68ddbe97a2e8ce4997d04e"
    sha256 cellar: :any,                 arm64_ventura: "2cdde5697ee00738429722ed6962b7bb3be89f00ae60a4711ec61bbcb0f63abf"
    sha256 cellar: :any,                 ventura:       "4afea5ed014156a1208bcc998b467b53480e2ff810c5802ef864ba8a7ba533d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "799e8bd4c5823aa30f9721ccbe4e93f8ccac2ab88e05ad0924f2ca891407907f"
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