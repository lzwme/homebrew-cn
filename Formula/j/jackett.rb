class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.217.tar.gz"
  sha256 "4b953341cbc925945a809e705cf473a5655623bd93bba2938d97c57605ec7d93"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09d7be7d1dad5d30d828f3f145576849c37b5091d963afcac2d58fe2fe8fcf1d"
    sha256 cellar: :any,                 arm64_ventura:  "1ae1b24452b4bbc99030022d2aa47679000be81b538e276c891e43f1745c5919"
    sha256 cellar: :any,                 arm64_monterey: "d1e1e4aff185df59b7fbd421c6377a4162b4710602af04811f584aa8a4cd0aa6"
    sha256 cellar: :any,                 sonoma:         "56f5bb4aafce9c1b5adf604859c124e4eec6eab282c286c43bd583cf836f2aca"
    sha256 cellar: :any,                 ventura:        "9636bac71d09e8b4d0b99df3109cb856ac57cd386a122a3345f7c0756ce8dfcd"
    sha256 cellar: :any,                 monterey:       "59cc80b941bc24569023ee1991031f475483b34f220fc681b8fc567573aebd63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9881885640f3050098b95d10b032ea188bea87417b2a9167563dd8af44fa4cc1"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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