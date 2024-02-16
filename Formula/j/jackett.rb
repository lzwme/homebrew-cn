class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1757.tar.gz"
  sha256 "29a837e4974ef5fd32dd666f2f43e67636b8a46e5c0f56cb6ffc2d988991c266"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "854b3a27c27ccb2fd582737b30631f236c2712629817262def5ba5bc94d732f9"
    sha256 cellar: :any,                 arm64_monterey: "dfb68adb769b88579dd2d2e6f4cbeb0757bd6a998cddb016a0d54a9ad6b80720"
    sha256 cellar: :any,                 ventura:        "cbb0209a35ec803d4d7014a69117b1d537f7700c91a25afcc0f0294bdaade4b1"
    sha256 cellar: :any,                 monterey:       "1ed05667b9796bfada4bb1d38ebbddaf4a49511eea6f27ff8ce9cf79cbedb5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de23d0443f9f4ae0b2e5d906d9e3a702328c278699e70650d48c36fe112011d6"
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