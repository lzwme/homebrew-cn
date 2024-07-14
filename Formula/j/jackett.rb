class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.326.tar.gz"
  sha256 "618f68ae05b7cedd75de2c64b392e1adf0a108c9c0372a91498b827cdaf688fb"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b56379ec5bb24af2d552070f7333e0a8ab8210b9f3de6a96ebdea31d0be3c7f5"
    sha256 cellar: :any,                 arm64_ventura:  "13f0fd831b5e4866fdb17f6f27c45c00d0a62d04c3549be749cfbbd7f2164e70"
    sha256 cellar: :any,                 arm64_monterey: "9ef9f1339a791701ac8a40a549e583f36d87a011207635bbb0d7bf1bf949a2a6"
    sha256 cellar: :any,                 sonoma:         "ff45710ef104be3b59cb7e48c8c83f756d2bc186387aea2fd8f091647237ae43"
    sha256 cellar: :any,                 ventura:        "8788cdf4a960c66bd4a689720bcbaa1fb25054ca3a467bbef519f920775dc789"
    sha256 cellar: :any,                 monterey:       "4c4bd10935338f9178ae06dffa73e21d76f256860b669949095ba7a0bbf5ee60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fec721cda7f0676ca773b78b45bfb344d9498b81fd9b3a83990c4529f02d9ed"
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