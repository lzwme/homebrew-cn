class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.209.tar.gz"
  sha256 "d158125afa6428888ee6fb4be732a58e741ba2e33aabb89ca29ca46f4ae688b3"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "489978d5ac570ba9edc6395a9f3a0692366d29ebe72c92d63dbdf80b55c0c908"
    sha256 cellar: :any,                 arm64_ventura:  "28efb8e150c1e9cce53776f6d9b4cf5e05a93f39ff5d14126fa77281803d5965"
    sha256 cellar: :any,                 arm64_monterey: "d500cc696a2a6fcf169648b400df3309e6b54af894e23486ade4ac4b35a5dc47"
    sha256 cellar: :any,                 sonoma:         "a2b0fdab0f6c0b532a004371a25a565fc82a9d8eb8f56210c942ec72e3244720"
    sha256 cellar: :any,                 ventura:        "30b2044143a84a82b201559cdd09027a37c23d23a34cb96b8706cd4b5db71bc6"
    sha256 cellar: :any,                 monterey:       "e5cff9988d3045b1745adcab4034a6afcc6751a7549a4ab85f0baee71011257d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5ab00d4ba3080e545ddf98c546668c044e1685d8ba9edcf5f87ffdbd52beae2"
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