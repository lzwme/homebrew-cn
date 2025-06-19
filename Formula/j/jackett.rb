class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2026.tar.gz"
  sha256 "1fcdd22f6cca08feb3af93ac6a69f49918b7be08c958b6bfeacad5353b62d32e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37cad7e6bdc99c00fdbd0bb22e323182e6e73a353012e000811894c0f1ef75ea"
    sha256 cellar: :any,                 arm64_sonoma:  "6424fe4bc205783e75651fba119be09a92778a61861feea70678b0d299bf168f"
    sha256 cellar: :any,                 arm64_ventura: "a254cfd48a96962b82517252eb01f597fabfb1e325b4148355e7fea41cd47a72"
    sha256 cellar: :any,                 ventura:       "ed6976650d23a6fb49402f39dfde689268af8a13968d0158e8dd73bfba8f4c3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e584f59b1e8e12c9fdfdc6a104140b63b1bcfaa3c77b9ca21a44a0f20025183b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40a5a6271c3d50883f630dcb7bff4c5963ed67a375ff790b219f5398a84d4dca"
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