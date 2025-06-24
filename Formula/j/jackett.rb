class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2042.tar.gz"
  sha256 "7ebc2965718861119eeced497cd7e5f2856c39d1405ce3584362a52fc06e879e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65a212ef52ae316382575c0e0959a3b81e0e015f9c32fee09c26d1b644d6d333"
    sha256 cellar: :any,                 arm64_sonoma:  "11ed98db860dabcf7a4c53b0094d09fba80b7eab591d5d76bc437ddd7df0bf30"
    sha256 cellar: :any,                 arm64_ventura: "517970845f2743604872a86a740ef3c72c0a85e6d85bbc006e67da29e32e3c70"
    sha256 cellar: :any,                 ventura:       "3298f5af90c07d8cbbe593c1b84508853db0ec3299206aaba640e09ba975a441"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b540f88af893abd6f96446f4c7a2b07fe7e0e39ea52b33ba5763ca600e5e6e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "955d3a536ab64373c69e89fd537f2fc49606c8441243433490652485cb3fb05b"
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