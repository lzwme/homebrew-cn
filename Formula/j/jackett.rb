class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.789.tar.gz"
  sha256 "9dde473d2f90c21b5ac469a77e039190e0cc8c34936127a8b23326f1a619e99a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21534225aa75950a92d8b7a519711ced3bbf09e162b41e471de91c3707e4830b"
    sha256 cellar: :any,                 arm64_sonoma:  "bb50b5111266da12193053bec1d49ce6fca7b1077b8707b460c88583f15b8955"
    sha256 cellar: :any,                 arm64_ventura: "8bec4ad80dfab2d80c82d534bd5fd6c55363e6bece1403379abe56b704b44323"
    sha256 cellar: :any,                 sonoma:        "750d5e1ba712c5cbf96271bad8a2892a64e0e7c50eace84537730d61d7cacb09"
    sha256 cellar: :any,                 ventura:       "1c930777121f96caec6469bf54e1326a71ea63073d6e5fdd92910a8635c32dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "124b37dd16397f5eaf2ee7042702cb94ff1265d577a2039c2590c22ee2bf601e"
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