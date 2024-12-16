class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1083.tar.gz"
  sha256 "477975acbe1f35b664d7b56f97610419e261678c676de33e48e543a0c359e51d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9aba62080207a839ba38025a8731f1bdf5c800a684f98ab6f30602ccb51b65f1"
    sha256 cellar: :any,                 arm64_sonoma:  "80c32d9c57cb8945a8647f68a21a8d0afc29e4d7fd6ebb086d6744ae79153822"
    sha256 cellar: :any,                 arm64_ventura: "c6a4db43fe7440ff771ba1eab7bf91c94271361092fc1077d0d7311fcad7b221"
    sha256 cellar: :any,                 ventura:       "d648536d5371b6939e989be573b096941b06257503510eb75c1691ea4a7e0790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f39ab9a1c5eef6cf7ff7e98c60640dae5b306c897d75e6585ffd3439e0d4165"
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