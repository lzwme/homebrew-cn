class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1987.tar.gz"
  sha256 "b5a70fd42773f7856061d2d6907ff58d2ffed82dcad7848c707762d6776764f8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "06ff329ccaa981c598a2678be45dbbd485982ef486e09205e75e837e4a382022"
    sha256 cellar: :any,                 arm64_sonoma:  "f49a8ad7b38fbfc0530dc78e99e19376c881f16f3a2281c636dc80898c8ed658"
    sha256 cellar: :any,                 arm64_ventura: "6400796b6d915bdcee38fcc3bb6f9b1fdd324bff779a537829ff8650c507f5d4"
    sha256 cellar: :any,                 ventura:       "397bc06772bb0f2f86953659f67f1d245adc94efcf4d74aac627245829bd2f97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73ef536d3e71c62e275ed587964850e3b62a3c782e654bb2ee2f013645ecf5b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9152af1d380bf8c5ffac3905c409e12c82d4f9d9166dd3e8d882594d8dbeac0d"
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