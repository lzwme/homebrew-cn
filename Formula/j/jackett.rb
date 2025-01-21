class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1289.tar.gz"
  sha256 "5337cecbd8451a5ec79046b95d7a3851bf91f5b75766a75a4b550e14f56680d4"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "281c772327a84093378cdff8f55dc394e7a63604c8069e19ca762a7dd4797684"
    sha256 cellar: :any,                 arm64_sonoma:  "4b8ffed24ca4ba6ebee713701806702aa99a2e9cb7168cd20bc36aa2030b7a3d"
    sha256 cellar: :any,                 arm64_ventura: "7556df105949bfe09cc0c81ebec4f4edce91013a68e5b8f98a83a03ebd97d4e5"
    sha256 cellar: :any,                 ventura:       "15353668a776b1726afa470d0e39758b7851c1b88b78a3dc66946135490decbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac781c6e7d7f9ac14ef9b490ff07b0504d09ab686971c7b28a8473c64cd4f88c"
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