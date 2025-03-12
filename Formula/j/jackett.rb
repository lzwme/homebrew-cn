class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1576.tar.gz"
  sha256 "925feec452c685bbbc4f6347e6ee455d23194938dbe83f70349d0046cb11d4e0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b251b840780ac5e21b8e13189ada168a0a38a24111c69ee4a1d88d75096fdc21"
    sha256 cellar: :any,                 arm64_sonoma:  "b5f43fd4a2a0c7980076c412fd2cd81bb7bf7d734a67262c8b196c56bdb8e35b"
    sha256 cellar: :any,                 arm64_ventura: "46b15fec702c11b2aba19d3c0dc132099789a7ab6c330792058e6b95c44f62e2"
    sha256 cellar: :any,                 ventura:       "8d27e260f4ddcc251220ca33390deeb88f331676ceaeb7b9c178a94cdb7c067e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4becdfdbc1a8c4d47d9c2b4c1bf3546d225d0566276e1159fcd559196e8919d5"
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