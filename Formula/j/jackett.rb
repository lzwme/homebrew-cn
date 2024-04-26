class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2458.tar.gz"
  sha256 "4fe395fd02e67bb205e524040a414e687ca91fd8c2ae775b987e146003fab779"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e60d1a2bf2736b4f53927ce5fdfcffce7c12134a3ec36823411bd4641b13ad7"
    sha256 cellar: :any,                 arm64_monterey: "03f8b5b459df0a61e68990bf6078c3405a22232b8b6ac3363aeba5349d46fd72"
    sha256 cellar: :any,                 ventura:        "ee34ec89acd847e0496141a1332ca28ab5c35a58f3454b75d897dcd9bf688dfd"
    sha256 cellar: :any,                 monterey:       "83c26ab9b0e0dd171451620ffd48f008ccd073e9293e10a4fba9129485f11637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e77b3e402f5fb94156c43379bf5dbb62844a0b9d96ab55d472bb49439eddb14"
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
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end