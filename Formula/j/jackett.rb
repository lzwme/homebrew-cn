class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1413.tar.gz"
  sha256 "4ce92180c9c73509536070afee2dd0133f2690553665459c9154d13a51b5a0a0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ff702ce3eaadca1d76b025ff8b63e38b737a69f91bd0b244f606011f432bc7a"
    sha256 cellar: :any,                 arm64_monterey: "fe6abc1faacb436697623132a4a090ab400414e82f5a6dda3d58a65c079d90cc"
    sha256 cellar: :any,                 ventura:        "bf873cd2a74ed43cfbbb4a83d6bd52a636aa91b37220da26bbb0b7d0eb345ba7"
    sha256 cellar: :any,                 monterey:       "e0d1cce60d18b633ced48e05ad7c944744634f549068d29a26fa85031a6b0760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b66e5e4f590625cc7115b43006e73a1a086485995ede71d135a99f48b0d07f1a"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
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
      exec "#{bin}jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end