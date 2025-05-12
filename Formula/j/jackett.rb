class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1888.tar.gz"
  sha256 "d1ee56f16894031c23f4758201881266b4846ab3a25501501e31b016550f28b3"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "02434793de24b9083a01bd7125c1039463808995706e2609627bfb524cdfc57d"
    sha256 cellar: :any,                 arm64_sonoma:  "defa1fd2ec91dd50a23c94f80a40c29a22e71f189b916d17fafda02b461f20cd"
    sha256 cellar: :any,                 arm64_ventura: "fa5dbda9e6b73e7dcc020c340c8567b75c95f9c0356367add531baaf1ccede7b"
    sha256 cellar: :any,                 ventura:       "207b3800a671ff073766aee46eb9547a5476fc6b2124bdf3f6f44b2a2504462c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "072a79a5f00015b65c9de331c0be8fb3066b781ebdcec77baa08caee1b19186c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce6ee78435625e160733bcb2b55e89709d808f5f3db7f6a9a35a18b28af3a912"
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