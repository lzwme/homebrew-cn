class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.89.tar.gz"
  sha256 "a5397a65069e14b2dd8febcf80d38fbcaa0b837aeb41985529279e6aa5014fbe"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87cd0193243631f557aa9673e40b298f6e691d8eefdd5058c1fdb29e40d46809"
    sha256 cellar: :any,                 arm64_ventura:  "d05498bc6a192d69df9b61f9abcad6d8636b86ad6b829f428649756f3ba1f704"
    sha256 cellar: :any,                 arm64_monterey: "9faf4be723eff858c904d7ac357f4cb3e03e2f68832bfb53f2a07b9c6a3f34cd"
    sha256 cellar: :any,                 sonoma:         "55ff5e83da398336a800a68daac4a5be448cf8f8447f6474f94707c935fb5650"
    sha256 cellar: :any,                 ventura:        "40ab30c861132febc1858cfc4a465423c7ca67d914716c9e65a69ea32185e8f9"
    sha256 cellar: :any,                 monterey:       "c8dcff68a4205265e70fffb5cd5ba23edf8fc35b408543befb5164d131992215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db69301a87c7383c92d66d60d73f3fa14f65d5368e07ef8b447a28601de37c2d"
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