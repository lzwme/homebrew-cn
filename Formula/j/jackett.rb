class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.103.tar.gz"
  sha256 "ad246bc619820c5fd35c5b0a2ff34088cf0ac01cc21b70dba0f3f31b71e36c1f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "42266d573be34d987f630ca6fd2f4bd8b7c681c70848f615240a41679f59f0be"
    sha256 cellar: :any,                 arm64_ventura:  "d52a9e51795e5ec3e3a4beb044a06c39c87e273bb15e70719bc37098c16c1044"
    sha256 cellar: :any,                 arm64_monterey: "b94583ce731ec9b316597a333d9833174b78e6248fa127967f71e59f9af5f753"
    sha256 cellar: :any,                 sonoma:         "d1b5c4aefcd101595e52b61e736a899bdd0d44f163d7df608c10711970d34d11"
    sha256 cellar: :any,                 ventura:        "f58d0f864b3f7267caef5c137c0fd45ba8981a918f439404c23f7f77340a469a"
    sha256 cellar: :any,                 monterey:       "5a08152f8ec9da288d0f4628feb6a2fe62d39dd2dae24166a3c212f8f9e2ecdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a78b82ed4284d615ace8402fc0b79f587bbaea16153d9fab16449023235f9f2"
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