class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1672.tar.gz"
  sha256 "f682e6e9e2df77550d29b9aed467024d81f2ed103cdae1fc9bf7ed75412842ff"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0f54a474cc24da15e79819b96d036f0e13371c333fdc9e906b7c0e4228e1041"
    sha256 cellar: :any,                 arm64_sonoma:  "267959e0f1f43f1e19161d3fa83c4f227045cdf0aa33de63e621aee655addcea"
    sha256 cellar: :any,                 arm64_ventura: "172d7d3bf92eb9fe9eca153b34eb79b0d8d06ccf5f133529c12c8a40d487d78e"
    sha256 cellar: :any,                 ventura:       "427ab260e3d55ee4d959b03946ff375447b4ade0cc063797a0514973a86b388a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a55823696b3921450eee442eb1fa6c73f18445f75dfa56352087e15350b01a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c02e0b704d39f71c5d9c935cbe9d2ea00943defaac202bc69915925f7df315"
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