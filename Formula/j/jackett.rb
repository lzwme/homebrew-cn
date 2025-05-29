class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1960.tar.gz"
  sha256 "6cf67569bac5e19c48a4cd6fd52cc8eb514be59f50b51ea25aaf44149233c23e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7be5e52f79bb5109aba97e4ea6aad3bbb3f19b8cbacd5bea6628faf9d0a53292"
    sha256 cellar: :any,                 arm64_sonoma:  "912fefb26adda59ec78e8bf699f6b18f2bf72c298ab39a861e65b6f3cfc872fd"
    sha256 cellar: :any,                 arm64_ventura: "816974b4590a745bf15f5bfc68008b738c933e25b8fc46a17685fe4a6d618e94"
    sha256 cellar: :any,                 ventura:       "c29b017c5e3201976dd0f74eb63707026db7a4d907be9201b6b51a92f710642f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc2fbbf225fe1323442485e9cfcc15a7e60b8a7ddb9bc5eb97371b6affa6ba52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "270cbb63ad56898793a3bacce2d5c6b365d3ffcfd3a5215c7c970cecb4bb000c"
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