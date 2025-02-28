class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1461.tar.gz"
  sha256 "114b0123127fcd724cd99daba79a79c342a1fde945504932137ebd6ef1f56fac"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "467528726aede7fa3afba8ecaf1837ffc106bb4e942389a6490fb7522e7af9ae"
    sha256 cellar: :any,                 arm64_sonoma:  "da08e44f2ff82963119a786447d811af0b1c4855ebedacc7017abd5ec847976a"
    sha256 cellar: :any,                 arm64_ventura: "cfdc2fda96fbd556e70afbb91f0608ddb41310e8478999868527500bb02ffb4f"
    sha256 cellar: :any,                 ventura:       "62dfadf05f28940db28e16fe40531f6b7f2d6aa2e963cce2e6896d1848fbdff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5488ac8bde76027c28cdef91c6eebe1b024a1efc96e8bb1740d3342cee4bceab"
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