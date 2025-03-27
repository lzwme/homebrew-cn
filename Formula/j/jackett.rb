class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1695.tar.gz"
  sha256 "275033f7f8e725791402c205c442eb53bf67c5d7860f801a73e286ad47ec04cf"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e5917c00a57de34b90f3c7707e1b4d892e9475137c64da1e290f1116a3674f5"
    sha256 cellar: :any,                 arm64_sonoma:  "33fcef5da74433105378b0df5c220a77ddebd94e6d8f51ea0fc1e64c349f8bc3"
    sha256 cellar: :any,                 arm64_ventura: "5220e84b3b756e9c73cc6c10781d6e5115ccf3c0fed6c7f05a52cf3417b45c88"
    sha256 cellar: :any,                 ventura:       "20f023c99bae0d8caab6890c73d12cef7b10e0a32ab6700dedf8242b447eaa08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "863f27768e8d8a6e019f629c3ea4f58b3deb713f607f9f488282b93ac808daba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de1048b767e642c74b4bf837adbf74cf32f5beee30438aeea74871ed5af50a44"
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