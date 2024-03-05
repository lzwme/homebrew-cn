class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1939.tar.gz"
  sha256 "bbd07c27d9169a418ba2c18030193cb95ed0d340febd55f6d60afd1a6814e15c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "704bc109d6128bef84845d5daedbd513467a33ac5823af4bb7e76ae0b225c069"
    sha256 cellar: :any,                 arm64_monterey: "73080b8887defbf0dc0f2459eb467adc88e738fe3528ee4d4ae4a7eb388064d3"
    sha256 cellar: :any,                 ventura:        "278e1440db9fd2dad0d63c13518a68c928656818d0016b4aa994b63e5c6962da"
    sha256 cellar: :any,                 monterey:       "2fea739aa8fd7b8ca6fbb90b9a5e2cbb1b45948dada6a8351694d913ce42c97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8800f8b8eb1162daed9a2e7fa85f27c2c58620c49dedcd2c0b1aec83fd8c8ba7"
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