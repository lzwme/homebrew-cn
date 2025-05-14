class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1893.tar.gz"
  sha256 "8b270321b36feafe82aa082f72e3d8f2b117201d92cfffb3ec05bf06ef80192a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "261febb8da0db589450da375de368e3831ef7666d2ee1c84f6c576db93fbeb20"
    sha256 cellar: :any,                 arm64_sonoma:  "a43c0e0cac0e9fcf93c1c87e2215ff647e14a80f4ea9f9d2828ddb1437909d05"
    sha256 cellar: :any,                 arm64_ventura: "24fa4523e6a62d8243d1bd010e745d9ec819b4f01551484ab0f41047735314e2"
    sha256 cellar: :any,                 ventura:       "20ae1d98c583c1fe39a99443da4610f041e556f708f27504b5cd883bdf01576d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aa9981f727f61b25074402189d80d2919d2e14ad0b7a3fe04a20adaf54dcba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d9ce6f0645862b5fb831589af25c53da946ff495350449c41762332d5040501"
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