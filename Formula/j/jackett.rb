class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1726.tar.gz"
  sha256 "3beb21737bd1377aa01495e32bf5f218f98f02f418e974d0ea1e448a9d031aaf"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fdd5f6cc231575be35c9bb5f7fbea285763d78ab242c0787d7ca7b1bdb0c4084"
    sha256 cellar: :any,                 arm64_sonoma:  "1c2efc47a7f4ff658ee9ebdda1067205e8f9dade4de50fc8c5edde1b7a53ab91"
    sha256 cellar: :any,                 arm64_ventura: "349170ecbfdebe1c074cb8267c8f255a1a79cf49ebd19f935e11ce73b2812795"
    sha256 cellar: :any,                 ventura:       "c155cd73e9f0fd3c2eb303eb9cdda003cdd0d677ecd898942f1a6267de568e7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c15998af07de75919f8047725cf491e89791c85420193e68d5a961e8af110521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13bd87e662a83fc43b6f6e8fed5a4518244658a28b9af43862b6a30f86ec4c9a"
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