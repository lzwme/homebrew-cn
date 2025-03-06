class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1507.tar.gz"
  sha256 "683829098bb1f57498338440a1db11e5e13af2c9df6dc17aafa18540650e973e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c95b3a6101801780ed228ad568065648e7d1746a351c8e939502119d50a39e1"
    sha256 cellar: :any,                 arm64_sonoma:  "4eee8c1977c5ff3b9fef242702f0282b97c63b0a90e8fdf11ae169ba47b8e987"
    sha256 cellar: :any,                 arm64_ventura: "13899243399f9f53c29db5be07b3f0e0094a91fbcec88c9dc1f69eb236de59ff"
    sha256 cellar: :any,                 ventura:       "794c7868ba7246da627f8c850fbe9c713cdca38125c0fbc64292f14a6cde5c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee38369732b9009ac1d6ee1fa5845f548886f75c593f7940862cdff7e66caea7"
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