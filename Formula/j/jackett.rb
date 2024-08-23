class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.507.tar.gz"
  sha256 "7e009958c1ce675156fb17d2502f4966e5ba464157b3be98b26bbfafd899225d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "faa6dbbf89dee2f95e0291d504ff64c9cccc0abd3993fb623e68d2c0fa7ea87e"
    sha256 cellar: :any,                 arm64_ventura:  "92589d9ce7734eb1530f7e4b01dfa7d3bb13e3b422eb1cfe86979402c16a2897"
    sha256 cellar: :any,                 arm64_monterey: "32edc5d173221754fe5e1e011914b93afc590f2b1da52d7dd85cc4929c2aeaab"
    sha256 cellar: :any,                 sonoma:         "be8494de6d00932a0c8b82082bd0de15bb044f1e97d9434543eb96bf08faa6bc"
    sha256 cellar: :any,                 ventura:        "a35c299e6ab1df5f313052cd68a3612fd16799eb03b2a58e78eddc2c3285e663"
    sha256 cellar: :any,                 monterey:       "283064fe41fc5e66d955ce5410c782fb31dff4c8df2a77d0a54d3c697b44263e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0902645e0be80be3cec6b62a21a1f93ceb4b90482a98e435a3568662d0f6e458"
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
      exec bin"jackett", "-d", testpath, "-p", port.to_s
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