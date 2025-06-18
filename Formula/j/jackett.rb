class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2024.tar.gz"
  sha256 "6761666ad5e075b2de221b4db31d5399ad59b9667291d083ef52ad948e44f0f7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a008222fd9f1a4f81c18df6d49de5a4fbe8a63c27e163a955060c4e6773d1723"
    sha256 cellar: :any,                 arm64_sonoma:  "fa4a417bb831c2d3bb0d475076a9f30d94628a1c09974fa7cf9982fc3f505271"
    sha256 cellar: :any,                 arm64_ventura: "f0422ccc70dfe5ea00ddc80fc0390772d4850d0847481e6d2d3218c2e73a31cb"
    sha256 cellar: :any,                 ventura:       "42cdeb907bb36a7a6fc22d62211bd528d1d560844f14b84dcb23f8bb19fafe12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d2fe5cbaad4f2941e7711b0289f56dcafba13e4f50aaf1f5ddd50f16864404c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe4b4c51a833523a6f246c6e8cb5d1ce7bef73f3e5c80f3100b3983107f1934"
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