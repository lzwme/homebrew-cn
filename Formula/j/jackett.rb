class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1269.tar.gz"
  sha256 "ed81bb5bdd4b133d1c3d238b4f2c632cc2e2405e0ebdfc7b33f3e0a38df5b421"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "994478a76a117ce7c25b08235d850e8b7e2a57e8ff4579a0679bea226399fb96"
    sha256 cellar: :any,                 arm64_sonoma:  "347fc2675a4ac761efa5b2266529011eaf5c764753ebe2ffcbe9627d460abcf2"
    sha256 cellar: :any,                 arm64_ventura: "89599a317d07c8dfe1548c7a95a98e92f952fc297260c00de42a037de35266af"
    sha256 cellar: :any,                 ventura:       "b729298a4120b627aa541187b896f1d53f4d6663ef851ef6299e7739c61140b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45314961d774b3c4d0ea2a441f9ce87c73b731e867b0e37e7a99ed1b47e3181"
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