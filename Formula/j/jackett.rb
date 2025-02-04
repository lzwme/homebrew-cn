class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1363.tar.gz"
  sha256 "39ad9341f73589d0386279a8d19a9c09d548a7e8c5c66a9a43d62b8a8d2e3c87"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d44f4f28e9917e71bcef2a4dc77ea38dc4cac635c661e7b4c32b7ffd61a164b"
    sha256 cellar: :any,                 arm64_sonoma:  "1903509860e7a71e44abf2b63ea14dcc78bf995f0cb9616a09e320d012f68c68"
    sha256 cellar: :any,                 arm64_ventura: "e13eb5a818c3cdf309f7b049e62b0ab2e62991d7027203cb004afb1c827e7aea"
    sha256 cellar: :any,                 ventura:       "85b0b143b81eaa2add40c449521f6385f8f4ed15cb52edb238971ba94df1c5a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb940e3ec814350afc2c8cab200b7955a41ef34556ac4438659fa4f1d430b89"
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