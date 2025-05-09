class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1877.tar.gz"
  sha256 "b1f8c10402f3162189ec9d8e55dcf77e4b47651c10cb0fee93d27b1e31207c66"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a68ba786fcd01a8a8f92118bd45853f1f25f869759bea6ca89065a4f8326656"
    sha256 cellar: :any,                 arm64_sonoma:  "0041a17567221099b194e1496b61533ceea1cb36b726304d6f3b8cf66068737e"
    sha256 cellar: :any,                 arm64_ventura: "60260079a21e4842ffbfee9b0ed77a39a6729106ce1a9360ac052968d1a94713"
    sha256 cellar: :any,                 ventura:       "e9c6b1d269584f6476c6c20f79e4d914f3d04f0c491600fb64d18dbeb25f2e55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1227515bd738478b0105389ea714d58fcedf45fcc65db9cb365511cf9893036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1583db21910fadfcb709c87369b2529b184de593e9e6c02a70a5069ecd0d52"
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