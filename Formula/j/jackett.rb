class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1393.tar.gz"
  sha256 "9b8d55f55fa81a8438a7bce0ed3dde70adf54f724f84a7cd6ba56847b13345d1"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32412c0b12764eebb8da12f4d220efaad81d1cf82b0b594a4d44554cbc66a92a"
    sha256 cellar: :any,                 arm64_sonoma:  "a78f4a1df4c168f34c955b2ecf6498e10f4e4ad2eeef1ecf2a6aba2707f28f47"
    sha256 cellar: :any,                 arm64_ventura: "c2042112867416c330ae4ff9b75e57293f72849aa535d2f3834adc960e812d54"
    sha256 cellar: :any,                 ventura:       "7c406011d8b84fd0a1c9db39e3120ab52514d7f6fc40538df7bb5b28b62a0cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e424a9bd4a9b6c1994531cbfaba14a6496cd655edb1e6c43a9834793362824bc"
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