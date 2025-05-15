class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1895.tar.gz"
  sha256 "1aaacda5eb4dc72bf6f8a28c7ff5063491580caef574cfb85b59acafaad6bb97"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "221a8ec543cb13914cb24ea56a73cecfc1b6161b2a107f8ee9a935ca1731f8c0"
    sha256 cellar: :any,                 arm64_sonoma:  "06d4ea349efa17e78d43ab418bb62dd5f3e9f68972e815475e650943bdf0ab71"
    sha256 cellar: :any,                 arm64_ventura: "f5a1bcfc059d7514db4d495c1199d1617e2b8ead9b8f96817a5c17a4da362e23"
    sha256 cellar: :any,                 ventura:       "f38b65573f144a599e30bf3752c23b82e514bd852e0244836fa2355f051606fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f66d640e84254cd2ecaef5a506833242d97d84c0243ffebfcc56896cb9eaf06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b9dc60189cf0038430fbb4e6f8ca61705766042d4fb99eedef72a041b59e0d"
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