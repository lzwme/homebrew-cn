class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.388.tar.gz"
  sha256 "e0bd4ad956d89939d742e69f971be0932304cd97e4b78f24b7cda6ca6af3c28b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d1450f73db3198209a343b43d2a75e283ce9e177fa2aa528a98a827a427b218"
    sha256 cellar: :any,                 arm64_ventura:  "25840f551596546a97f4a2d2f358adf703ff0a207e39ba497ac0687fd676f7e2"
    sha256 cellar: :any,                 arm64_monterey: "966340214d909a1347db80b1e959873a7771262d4f0625d0a9171908828bfa92"
    sha256 cellar: :any,                 sonoma:         "1b08c567c92513d0f69eeef512c7b4ddcc913e8283f27ad62c9a33637c54df20"
    sha256 cellar: :any,                 ventura:        "1f4a25fe8096a89bf875ebec0a58a4eead8e02e2478e5ca09306939b72ffeeca"
    sha256 cellar: :any,                 monterey:       "948a1265e12fab5c4e179f06db5f38de8bc3aa4f7bab703b432ca0e85494ddb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab86d933df838a965b8ab420ef5c77af829b17b0e9edf9ec463eec1f28d87b2e"
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