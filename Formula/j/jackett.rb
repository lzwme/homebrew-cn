class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1775.tar.gz"
  sha256 "ffa60b36408e2034f13b452bc4eb0b679b42b203bdeee923ca1c57c897101daa"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ba7ebb23c7a645a1bfc1f6176ecf65a5e38e5c579ddb092c35a8e0b6229e3c5c"
    sha256 cellar: :any,                 arm64_sonoma:  "5c1460f51f178023987af25be2accd1e25cbe2973e2f2d3385edf62da634c96a"
    sha256 cellar: :any,                 arm64_ventura: "310f19905073f2d295909e2e25ef339e7a3d8a84aa1fd35ad5203991e4bdb036"
    sha256 cellar: :any,                 ventura:       "498423fadcb0afe6dc209c02ecf676c04719bbeb7340b7e4118a07aece9749c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b7ca1c5bbc53f834aa80ff17aacb107709bf48c16bba3f434efafec0719866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "435366bf79b0e3475b4e85a8f3fe7f5e53bdb867549541e8fe73d34ed1868bf9"
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