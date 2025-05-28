class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1956.tar.gz"
  sha256 "ab55384450ae415075a8d7414a3fe30b49d6554cd57ee8716089283804e857c9"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "25f35dddabab39b3ae6ebd4fa50a409dbdbb908f0e86fab3dd8157b626fccc8e"
    sha256 cellar: :any,                 arm64_sonoma:  "247b78f9923c8cab569b2af2885009c00744cf7eea06604d08c0cc57337db7e1"
    sha256 cellar: :any,                 arm64_ventura: "69155010ab00bcb05f79419d2a1f4fd71c0ac96ac5cddc6bb2bc9b2b424f34c7"
    sha256 cellar: :any,                 ventura:       "82085c732e7d9b03e4a5dffba68d69afe5ddab96b3cd826ea5500e2e963a948b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed0a8facc79c8c970068018924e81a16a1606a6de2113e0e81e32a71af1b63da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6687be97cfcba3a8df6f716a2aa803785ecea943b1cb6047af670b5a4abad705"
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