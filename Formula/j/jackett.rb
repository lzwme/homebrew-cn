class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1566.tar.gz"
  sha256 "a9a5aaace403317690e274be23b089b783bcf10d00d1aaf7c44f0f12eb39d486"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "109cb24d03358cf6bb6721d378f219b82feb36db345f436bf4e4f2aca185ccf5"
    sha256 cellar: :any,                 arm64_monterey: "f4bb0cb14650b24b27d418de2b2925d299ed016937bfb85056dc42ea50dca165"
    sha256 cellar: :any,                 ventura:        "c897e0ce048a59847537f13874a1306e4c44efcff1776316961bf5d7538b5bb5"
    sha256 cellar: :any,                 monterey:       "a29592582a8b3746fd20cf40dcf1effb362f813ace1dca12f1f7711b2060b729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2478626c44d5c646e5cc7b9f35b28f23b928a0c6e8043888095f431c0b4d3bab"
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