class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.396.tar.gz"
  sha256 "d49731d926b0f3a6328cafdc50d3900fcf9bc844d1b9458db817401a5d0bdc5f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3e3aa94bd8f5286c0afb966d29bc58e8301b243f93402cad2c837835caf1d8d"
    sha256 cellar: :any,                 arm64_ventura:  "0fd5f0389487b4a98e83fb5153939e238b3e39b6ff658d5ff9f76eb6e7597d6b"
    sha256 cellar: :any,                 arm64_monterey: "c434fe643b5a3844c945e327e59463ec900c6d53872093d714517a30f0f160b3"
    sha256 cellar: :any,                 sonoma:         "f4d48c4532261f504ab0ee0cdb8ecd80d5c0b61967b26185e9a01074a1252fae"
    sha256 cellar: :any,                 ventura:        "5d47ef729f8f78bd21717a1564ed9548ee777acc65a0d6ec5a9e150fe6220294"
    sha256 cellar: :any,                 monterey:       "4dc0fda94bff3e07e28b81737507f5401dc645a060896e75d555ab5f44afaef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62e589bdcfd236bf41927a709787965de2a61724b48fd2f8e79c03896d15cf4b"
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