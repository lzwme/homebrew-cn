class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2064.tar.gz"
  sha256 "91a4a2ca4f7cbfcac430f16c98b2bec6851bc30c4c12d18a5f40cba75d34e61c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05594b98d85c9e608b3b0a7b730346b37974fa6f05064e13c1673917f9fead0f"
    sha256 cellar: :any,                 arm64_sonoma:  "62602be633710613a746c805a71a5cf366936916c8c9564a56f9eb9686b589a1"
    sha256 cellar: :any,                 arm64_ventura: "ddaed6577655fcab3a2d7297f4ce44f649e5e6383023b49f0fbf4912d04eba68"
    sha256 cellar: :any,                 ventura:       "045ef82670ef2125ecfd42adb266ebae061c9bfe7ba5ab985b616483567c1659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6df25b23e70796b187e0bfb3ac6c90f8a6f7eed8ee3b41193cbd6b4d548a3b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d36ed6ce30e13cba9f220d329a49c6d701285a0d0963614a38fb2ef5be1ae67"
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