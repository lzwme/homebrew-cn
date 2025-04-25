class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1822.tar.gz"
  sha256 "ca2e567cbe706f65611a8767b0174bfcfa716b8169dc5d092e41374a4c391934"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1c935caf3d8fb532a14d09a45cba095bdd86c7119febd6dd63fc8b929f58c55"
    sha256 cellar: :any,                 arm64_sonoma:  "d1e65b3640d23e81527afbea8abfee18bf5a89ec79833b068980ab8ab30fa83c"
    sha256 cellar: :any,                 arm64_ventura: "94a86e684580a675e9e27d1884aebb3838f6b76fcda87fc0cdb233574ea4711a"
    sha256 cellar: :any,                 ventura:       "b5c13e7a9970866e5b1592e0a301dad93cccf4c481e62d062238930aac522906"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e88def7acdc538618942a6fd4dc3d3eb66ecac46d94fe7c562a85d4b328428b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adeeb212929f801cec9e82c76ce617c3e693cd0b44945798e559cab196d86aad"
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