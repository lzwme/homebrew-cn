class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1103.tar.gz"
  sha256 "70d76d492acf776de149eff13d3e9b4f9b8863cc890be94fc0895b70c4bc65c3"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d78b4188351f9d719f7b98af92af287d3f4552824cc53ab5221ea4c3316cf11a"
    sha256 cellar: :any,                 arm64_sonoma:  "3a74ff84c062ea17144c69efec4056e1a03f13e4ce791de8eaab2bd24539d3c1"
    sha256 cellar: :any,                 arm64_ventura: "7b1d151d0760ce9e015d1c16df05677c72dade8a1a4ab6250c9d972d71688b1c"
    sha256 cellar: :any,                 ventura:       "28c1dfa9c06867ce192c764970e35380d8084109b83148469031ea24a8e709ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "008a4ebdbee82933923e497e1adcfe9bc586b0452fa2bd4e8ace2800f2c1b069"
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