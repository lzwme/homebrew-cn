class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1009.tar.gz"
  sha256 "fc02552ddca8f8b1cbf3dd96cc3331b9be61ad11508792a585e3c6945185e3e8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d665e49a0fafeff4ba7545a59e73bc6aa58509b522dc6b81420675248f818ea"
    sha256 cellar: :any,                 arm64_sonoma:  "ff7a43cbff9ba9646b68eb13b812515cab8d4395aefb0eff2341211bd52c8b74"
    sha256 cellar: :any,                 arm64_ventura: "60c4f6729741182de71340c59a096eaa601ebed6e18b383045edf9e29b854099"
    sha256 cellar: :any,                 ventura:       "ccb5d7032a2294a942542f0552e7d2b3f72381bb63cb9c09ef87662db8d8ef73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "612eb403c6e643fc6043f15029d2c260808bc75f8d208ee6bae091e01675bd0c"
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