class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1355.tar.gz"
  sha256 "0491fb691108386f3bc97aa913783ccdb576d07c2ca72cee9fbffbc9d27d7aa7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "31f090a835c46ab14414ce1fb023d3f8f494c8fa7861ba2acc010974360438d9"
    sha256 cellar: :any,                 arm64_sonoma:  "89922b7c93db12a1d4d151f37a0b3cd3d7203666b727c5d79d3c6092b262dda6"
    sha256 cellar: :any,                 arm64_ventura: "bde71c190bd69adb55388b3e2e33362a980191c09c6af545669ebb2e51d25b27"
    sha256 cellar: :any,                 ventura:       "12294c77fd540d4cc0959f59688aa49ce707d5ffb43b1e3b4eeefe25c72a7100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b41716e33d2a82932130eeafec8e875159fcb5d122e3ddc19f10138bcca78c"
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