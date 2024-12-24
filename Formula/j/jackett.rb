class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1111.tar.gz"
  sha256 "fa087db310f7fd76369445ddf5b46c7770d786e302340eeac98cc836e16612e6"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8689465e72199450b2e4e9c3dd44581565d18d768b765381d7a981ce6711b444"
    sha256 cellar: :any,                 arm64_sonoma:  "f859434b2e4e1f0e510439e9ac0349611c2b7f3f63607674e402a567897259cf"
    sha256 cellar: :any,                 arm64_ventura: "c43f1d876a7b138e5fe658834b003ed049a9cdddc9be925617d92a59e9397bb2"
    sha256 cellar: :any,                 ventura:       "d4d4a9cc6776ffa7db591ec6fc3a52355bb9607f2f1a3f0a0b1143dc0c07ba1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3169e74de1098794b0637c6b4db15d3f9b9567c446c648766d418520d66284e"
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