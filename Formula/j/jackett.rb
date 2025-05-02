class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1837.tar.gz"
  sha256 "ce773d10118cceb94358f18d408bc985e81a621ee07eb8698984df2aa39748dc"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8bb3c483bc2787018d76a15b6b84edac971c31ea47e5c8e3ba2402d621ed0df1"
    sha256 cellar: :any,                 arm64_sonoma:  "bbeb8c05708d0a55d85281ed5a9196aef99c6e4c38e1663ef98dab5088d1a492"
    sha256 cellar: :any,                 arm64_ventura: "d72ea170690d490595665d408db35cf05e3c984970cc82d6098890ec50af75e2"
    sha256 cellar: :any,                 ventura:       "0ed5c31556e0bafb2e07650a305da5c22945bd63521298f0b1385bcf54547ba2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afdbe8266125b8093d7ffffa87e617ebbe55db801c4f572d64f4b54a8508379f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40db393857fb2cb458365aa82281de110623601e174f31f329829cabd089942c"
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