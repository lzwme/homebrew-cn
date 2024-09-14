class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.587.tar.gz"
  sha256 "7c222d86886c2508957f4f384dc8136566309c21e134e214f297fee0da3c064d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bfaf4f6148bd22d37e884097e3f897df9426b3f8078d1b368b631178c14336be"
    sha256 cellar: :any,                 arm64_ventura:  "769e6e6066cf3cf03dc33599080cf71139e578cb49ba46705764fcbc09970ca8"
    sha256 cellar: :any,                 arm64_monterey: "76a1063281191d18f04f947157ac6f215d57d175995ee9419c1e0e6d19e93b17"
    sha256 cellar: :any,                 sonoma:         "1c385a52f05c77ae49d2473cfae8cd1ff249e5e662788391d042b6ef2750ae7c"
    sha256 cellar: :any,                 ventura:        "3183f6b891ab1ce78ecb3b12b6bace17eeb9dab97ca3bdfc11e1014ae83cdf30"
    sha256 cellar: :any,                 monterey:       "7938a3e161c2786cb4382498e692d856c278f62a3d85debb1eccf99143c3e7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "478e9baabc654e0cbd11b91dfb0b14e02ab37f3f3edf8ffd7a984d0c8a526d40"
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