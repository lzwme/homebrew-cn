class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1162.tar.gz"
  sha256 "35ee052bb2fa9cee2d2e98579b5ac31d553950d74164c3f068de5d5e87164a26"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9df3c0f5db7e59c08e1b50f414dd8200afe2db9193e32430cc36eb216e897617"
    sha256 cellar: :any,                 arm64_sonoma:  "20b1e8d2aa421f69305108a82278661f62c7ddb7e6c30929d0c56eb2f519e863"
    sha256 cellar: :any,                 arm64_ventura: "d4f8704381d96c6be585e3214c18c7c7a95447bbc9cbea295570d74e15f7f8d5"
    sha256 cellar: :any,                 ventura:       "80cc7841894fb0b4f661842e41336f8aac7ceba15c7485d2c53a415da5154c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee2dd85a0bb1c9a815948e17cdf1e163f555716f94aa4bf79257c77f7e0e496"
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