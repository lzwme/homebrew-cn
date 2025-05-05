class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1863.tar.gz"
  sha256 "acfdf1f967208eddfe1488e29a3f924430ff3780a8b983147164860cb0d19891"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ab16e81959d45a77625c34b6ff77fad55b4905eafa3cce13317588f4564a18e"
    sha256 cellar: :any,                 arm64_sonoma:  "5ba643c858a1c524701d4e9e48a79b12ac0645e0258384a89cd8bf3da4dc7491"
    sha256 cellar: :any,                 arm64_ventura: "19e23f2f4ccaaf3a6ea6c0679145450ff61cc15b0916f62e3d057361681cff4d"
    sha256 cellar: :any,                 ventura:       "9dc4b1abe344f8dba09782889011f1591f1ae5f288b866891bb5921bc449ac59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "079917e05b5e9c97a9e670dc5e9bccebfd9524b8f3ee18deae966642e98309d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86699befa46accdd56b1c3925ca148759e4a08965b07023d062b871c73dd10be"
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