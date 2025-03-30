class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1705.tar.gz"
  sha256 "797516d412862c46ee37f94ce3b354c0a9e2a2f5a01593658b56728ade02c2e7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ba6c987b923db67b360cbe7eae5065346fd32055657cfff47b071b5ccc138d86"
    sha256 cellar: :any,                 arm64_sonoma:  "d99b10c2d2f2feaffd2ebb369f30dddd034879fb7eedf7bfcbbad0ec417952a3"
    sha256 cellar: :any,                 arm64_ventura: "2a2b3797483b83eced11ef1a8c13d67591f336b24a7e9b4939b43336f635c53e"
    sha256 cellar: :any,                 ventura:       "5dea7eb4523542b45b646cf03a82d54ba10e243bf58c74ef9a022355d4a187dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e34932a177b34d03b65631ec2518e829d96f1b8030edc5bf7431f9e7a7e287cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ffca6e3bad0f733a4a3c2ea034e57fd636b2ce00ba9097bfcefbeb56ffd5566"
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