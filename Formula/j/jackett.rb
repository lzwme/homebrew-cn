class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1368.tar.gz"
  sha256 "b298d2f91235b73f79d6b4c46d3d7f4cb5a5271a540e17ee8dfdf85d302223d3"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b24cd78f57fa3183242c97c333e952135758f90e2b63547abb2cc96d991efa7"
    sha256 cellar: :any,                 arm64_sonoma:  "fde5667ff7ed799ce94174aa13477b8cc177b41e5eae2f2d7a163e8dc0267b08"
    sha256 cellar: :any,                 arm64_ventura: "85eecce3a9838b5fe33b8b1fddd8e7f80f2f0cff88b0a16e61b9e7f97d1eaecb"
    sha256 cellar: :any,                 ventura:       "c99306876552acb1f12098dd268e39b74f4fde9c8404835d71b22e4ada1f45a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd4bb90c84d9835d80c33e7f930a51878ed409d82f60a9e2f6ecbba308a47122"
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