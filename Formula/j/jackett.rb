class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2358.tar.gz"
  sha256 "6e5787f7d9fe378bae47aa22dca2147d8ca69c03779b8fba79d65f3ccd15a5b2"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4baec7ce889b781cc426f4144bf79e447ca5bcfb7e8a07548f68ea6728dddc7b"
    sha256 cellar: :any,                 arm64_monterey: "a3545f4f9ba3a34e11e10738a4b56bbdc125fb1d2faf8b938893d35955507aef"
    sha256 cellar: :any,                 ventura:        "39ffcde057769a05709f2fdffa30410d391000b55406bbd49703b63fac87342b"
    sha256 cellar: :any,                 monterey:       "87a545f9fbd513a5c187cbdec7cdc0656751bd4520977c73de42f326105e67c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "655916613cabaa1c8c1110f41ade6a6eb41fbccf20e1369779dcb81ccb1485a5"
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