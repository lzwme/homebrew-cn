class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1445.tar.gz"
  sha256 "5fb5522794292767d72db7733178b6ed2d822f37ee1b3178fc38d7baca23c751"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a55290ced65cda37884a3840fc629300a46a47174c40fbc4e3b430741e144766"
    sha256 cellar: :any,                 arm64_sonoma:  "a0de1bc7a66637c05dd17c7efdd5bd43c7a23bd9058115be0ea619908d5b19a2"
    sha256 cellar: :any,                 arm64_ventura: "2e1657af0e601d8a73fee31625d7aae81ed91eeb153b7d2b52b831dbdf6cc24f"
    sha256 cellar: :any,                 ventura:       "21ad16ccbc02b8a148234d7dfe388bc741d4c5fcf4f5e32fba1b71066f8e1b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94ba360dae8c14842838817475312b1d5980099267c6bb7d7ff0ec87a66d3934"
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