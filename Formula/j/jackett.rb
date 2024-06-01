class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2855.tar.gz"
  sha256 "cc459f59bdb57bd7dd5706c034132292a6fec5e717969aebd1d492e6e98117da"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "128cc4f50f33c768049f3a76baffe38d4388249cdedb06350cb295011a1a4dec"
    sha256 cellar: :any,                 arm64_monterey: "c0dbf310ed9cd23a305b01d23cd47b6e82b5a6f56d174cf53d1bad55d122e23d"
    sha256 cellar: :any,                 ventura:        "94ce7726158144e8205bcb00f3c64ab496dd3a2f324bf07bd3a6a5702b86fa40"
    sha256 cellar: :any,                 monterey:       "bf0c303e9fc4b3bb3ffd723b28b841357b2b80cf299d4517463b660b50810023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0b2588215b5683cd2dce07fb95ff833905ea564f6181823be1bf16bf49eeeea"
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