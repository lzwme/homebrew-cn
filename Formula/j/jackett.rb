class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1897.tar.gz"
  sha256 "279ddf075139ca85b5cd6086f46d9b7c7aca964f7b64505e78da7f5efbac7da7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "924e5dc1fb29247e140510f70de258c0c3e059de021aeccf5ff39ae765ef7578"
    sha256 cellar: :any,                 arm64_monterey: "d27592d8b47a9fe70a11f6ed79ed30e9d67a4af6879239f3cf60f83af3cc2ea5"
    sha256 cellar: :any,                 ventura:        "7e7e90138fb1099850098372a6ed235868ef5e2eee3532013af6c5c91df659b6"
    sha256 cellar: :any,                 monterey:       "347e3ffcd1d69c35b2bb771fa3d02768acfb47423cf873675261d376390b7620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0729cba712e6c0555c1ff1156c6f30d0b5a8c7ed153e2d721cc0a45a68f6246d"
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