class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1685.tar.gz"
  sha256 "9c7da5da0f98905de65ca82b99b516b4d8bc2129f1fc277579736ba6f075dbcd"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6fccd475875222e8ec0fbb28118613db909f1c1afd1cbf992ab3c1977efa1b97"
    sha256 cellar: :any,                 arm64_sonoma:  "63047e9d8b2c0cb7827a0491c1f090aa196ae04fc584a816c1f7b3d8fe614533"
    sha256 cellar: :any,                 arm64_ventura: "10d475562b15db3af40359cffb55fcc8a9b8d93306463f191db6ea0386e07acf"
    sha256 cellar: :any,                 ventura:       "6b735ea5862a951cbe13a87906ecbb2b7db29aa6f1eb768bf7d111a85e4674cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "762a8dbb6ccb2045b576e45adebff40da3f30a9aad9ae3e345665529989a18b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f37323e5386cc4a42144b5ac36defad951cf4e5c68f7e2470d15ec9e522450d"
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