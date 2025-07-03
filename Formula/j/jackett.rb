class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2107.tar.gz"
  sha256 "9d263067343a15ee1e1fb95933a14162156013921db18c4234d14ddd2ee21db6"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dc1665cef958cd763d3e1d1a63204607ce045557050cd250f20659beba672888"
    sha256 cellar: :any,                 arm64_sonoma:  "f5d3b69dd6d72db9e109fa52127131e2a607e53660e8bcced289e159341fc180"
    sha256 cellar: :any,                 arm64_ventura: "96b3066a8a64b126bcc8c71c14cf9d63c228f84ab88b01eb99f9765f707559fb"
    sha256 cellar: :any,                 ventura:       "be75ff73002e66c172da6e4b9bd4c677e2250a4b12779e6b15a2114dcfdde687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb65602f062842966ea595fb6d1c7f0ad295a60be149f35649e3bdee959ee5cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c621876b744f15b01b7830fcdd790ad262c96132d1db27d03e0db10e6029834"
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