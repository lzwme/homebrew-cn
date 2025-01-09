class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1218.tar.gz"
  sha256 "1426cabffc750f4985b27a8253f35a87e50fffce7b6eefe149ce9e672345dbfd"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89266a06e2e46406d8e865446d0320c800d1f825dae9f5b9aa2f5c2e1771e7a4"
    sha256 cellar: :any,                 arm64_sonoma:  "182082373c7c8083c47187ec411ed3937aea389d4ae74dc3272983a3342efcf9"
    sha256 cellar: :any,                 arm64_ventura: "faf669bd3e2bd438c1d5a092207c0891d4c62c82a36be0baca221a525fbbb75a"
    sha256 cellar: :any,                 ventura:       "b36d5e97a3c05eb3b58d49c8e7e1914ae3bd8adccaffb0461b54853dc20c125d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b8d78331f62ee659dea63607025f3e8786ce6206fec48ae2841ed30eba160f9"
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