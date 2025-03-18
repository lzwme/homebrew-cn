class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1646.tar.gz"
  sha256 "01a4d29ea06bde030296dfd57f92f2d99044c91dd0cf00e3249e8a5f043edbc5"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5685df4f72dcd073026fb68803a7b27edb2c908438ee6c2dc3d54cd40e08e4b3"
    sha256 cellar: :any,                 arm64_sonoma:  "7fa24cb5759b0af25dad47ca68b60255326c90031d82952df7a3a78810509db2"
    sha256 cellar: :any,                 arm64_ventura: "89ec8411217f9ca305328af766310e346ab36a770d455fa73f4c8ba57b498a1c"
    sha256 cellar: :any,                 ventura:       "22f1be51ae369cc1a3f26b9dab9cbbb50c0580280d51ded07b94b5b5f4fea77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7b35f8abcc0ef7217a548ca5fb460edd1a7ae7139ee6b210f24059963a3609"
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