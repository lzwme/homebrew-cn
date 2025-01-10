class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1224.tar.gz"
  sha256 "185cdd1a6f6c8d0d0692f388fddf43d71bf91a75dd685716a28b3587cb00ccb0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e232f85ecd537439f7b6584d64bb1f7edb547bbb05fb1c977d84446a9c8f757f"
    sha256 cellar: :any,                 arm64_sonoma:  "76d34ed8a258946a281a6622c746520a43547805735d4bffddef3bdf0469c599"
    sha256 cellar: :any,                 arm64_ventura: "5364957a562cbeb8db68bd4f44b47734f9a309c2f498c2a933857fa2a3ad23b8"
    sha256 cellar: :any,                 ventura:       "3c69edf29fc56f34598b46fcacd0a27211e0b6ab842037b17ccc8a86b90d0aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6996894759501b3601b1021a1eca22b56fbecdd8a9b1aeb086d694fc987de227"
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