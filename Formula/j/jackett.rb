class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.200.tar.gz"
  sha256 "af3d0b211e4aa776b0b94f91fa3b641f75be2913ba909ff9afc70a437e6bf41c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0c288d0d6829d63ec7dc63643c11263420beaaf503a8c1349e5409881a9f3c59"
    sha256 cellar: :any,                 arm64_ventura:  "4e4e3f49adb8fda52c73ae1d2dbef326c38b3d6a534674e34aa30b4810b7638e"
    sha256 cellar: :any,                 arm64_monterey: "9d3bbfca7cca7e3fde4c6c900b3e9b28b40deaace91f1452e0a14555588c70ae"
    sha256 cellar: :any,                 sonoma:         "23767d250efcbeb1ac6616ec544b197ef0dcb067beae9160bb924e44649affec"
    sha256 cellar: :any,                 ventura:        "6a40d843ef160677e97011b1026603ac809ef25db71fbf9d78c8f542903f685d"
    sha256 cellar: :any,                 monterey:       "5e328289fa699885692a0c0718bf4fb4c40c0d70c3ff6907bc3e7bd548326b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b3f59e62db88343f194adb78c20141da09dc3c2f533dc929bcf3166bae5dd89"
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