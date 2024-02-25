class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1832.tar.gz"
  sha256 "dec3e9be64eb7e70ef6e4aaf5f9f1c754d8195adb458350ff8213b9e5681db3a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "14e889183c4cde449c12adaa5a699f1297e515a94db05aa6c03d84f14f77a1bf"
    sha256 cellar: :any,                 arm64_monterey: "ddece517f9d3fc483508d13a851f75d0ccba3411785aef40c4c0848e72b2517f"
    sha256 cellar: :any,                 ventura:        "2eccd408789a9a400d8c2f7d1aaadd906d402b8e4d6fd34819b750b0887ffddc"
    sha256 cellar: :any,                 monterey:       "0a98fcf35dbc3ec95eb002320903bdad5c99f053ecfe752248413f508cb59094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be703a739b549599f9d55b75f3dd35e9f6baa3f09adea0e4a7b667fc60fda018"
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