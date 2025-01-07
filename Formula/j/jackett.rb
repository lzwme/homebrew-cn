class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1211.tar.gz"
  sha256 "6afb9a9ccd05c08a08f0f4bc29d1fb935cef0ebeb30f65d2c6a807ff7150ce7b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c793eda7a65de9b4668b99c7172211e2d0bbc15f851f40d00aa3cac3499e3d92"
    sha256 cellar: :any,                 arm64_sonoma:  "8653ed5d766170f0e2e263f036f931240001449f1529160f8f32d3161b4eac03"
    sha256 cellar: :any,                 arm64_ventura: "53a815a36896c34df40c5ddbd13b13d8bfefda63269716e9591f283c82898346"
    sha256 cellar: :any,                 ventura:       "619bc6175dbcf0bf33b8464342fe18fd1b3a7aa781894c506858f5cb5c99ea92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e22a86873ececec66c0023ec393d25e262038c03c51d40f7901e9e5933c211"
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