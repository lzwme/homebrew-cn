class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2111.tar.gz"
  sha256 "f4256cdffe55c2d934ba33106b38f3dd7fad167d1517491a6ec32094aa8aa445"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7508f0078618539388ffebedf6ab72c8b1ed022a82f395ebbbab99aad55347a9"
    sha256 cellar: :any,                 arm64_sonoma:  "e4338df70d9be129751a2f9dcfffa538b0023d6247c229fb073ba99493a1bee9"
    sha256 cellar: :any,                 arm64_ventura: "1202923168576dbf16a92ba7c2671aabe11b15b83a52a984f42f922112c05f68"
    sha256 cellar: :any,                 ventura:       "cf96691a085a081dc024f5a25006841ce1a5956b18287dbe00d1e3933bf94bd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40bdeef6bcab015de2dbd4e57062fd464b82cdd951e57cf9e8b4fb1a8513090e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5e7df93a31bcf52ac912893d1b452131464c4454810ce438a562c964e468a0f"
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