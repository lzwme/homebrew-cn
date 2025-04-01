class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1712.tar.gz"
  sha256 "c3068aa4104a2b666b4c785a4133d72a61a026da0a3cbb0e872b449873199d9c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6dedc5878e56fa0b24ec9dab8c39c43b19b50c4a9b3eb57977f9ee608a86dfda"
    sha256 cellar: :any,                 arm64_sonoma:  "f88b2bc84f9f0547ed8cd262424bee085724008dd2249840cb952133f822052e"
    sha256 cellar: :any,                 arm64_ventura: "cd718179ec468741cd969982084c7cae85fb4805ad94ea92636a1fc3a4aff837"
    sha256 cellar: :any,                 ventura:       "2c95fce9c44db22f08c9f8e2da75ba26b71c94ba14dd7265a31efef4e0aca840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9834fa775139841eabb4a1c461e24904c8a0dc31d12b44c9230b13d7ee8c5719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0d85690ac42c4d0c563ee8f50178d1aad2caae42de77eaa4d90796f26bdb86"
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