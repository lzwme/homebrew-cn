class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1074.tar.gz"
  sha256 "4c11010e9926f3fed8c3401d23bd0bddd4634af1c3638f9a05d65a12101a2745"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "afbc9096247f88737e98035ae3508b9e90d6460bf5dfdaf414b6b2c3086e02a5"
    sha256 cellar: :any,                 arm64_sonoma:  "545f07336948c67a50d54c243145c43510bfb1a501db37d621662be5a2d594f4"
    sha256 cellar: :any,                 arm64_ventura: "4605c1bd1ec66875047c51091fb5e834492c7055fc19726a6802fc567a3e3edc"
    sha256 cellar: :any,                 ventura:       "a038693b5a28244170d8abca6e2419e2d673b5b0c76ebd09e3246f113cd68279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdcb425d6c38d35ab56d9bce28591352d0cd018f54454d596363e54d258bc2c3"
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