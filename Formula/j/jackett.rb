class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1463.tar.gz"
  sha256 "5769ddf377f1a67c44ada21b2e6f63c0f14f1863eb990d22240281ce7afa455e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9bdc4a7177327723350e785ed4b7c4578c6cdce8245690e09ffb3d3231ea289e"
    sha256 cellar: :any,                 arm64_sonoma:  "fff14fd9ac1eacd88b40f1fcc705ce992ca280761073334725de22be27d95fd3"
    sha256 cellar: :any,                 arm64_ventura: "ce56ab3d3fb941ece96ebed79293612b361b028800f00417ea9f50eaf11fc89e"
    sha256 cellar: :any,                 ventura:       "f1d3a75531cf8f70ca33e7b3618e93e66cc46013319ce4c31123351cefadec48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc3fa58e8ccb6c4529133a356a50dbb28f8bf9ed1367d12fb5d04720d20615c"
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