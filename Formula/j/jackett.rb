class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.175.tar.gz"
  sha256 "9151160082244909f80cdd11551a85f4382065bf1e9bdcd5937cb632d6c46730"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ae44d467b0e86ce7ec75ade8d53cc79baa65eb3f52dde93fe4570e68c4b7e88c"
    sha256 cellar: :any,                 arm64_ventura:  "bd6afc6040f15aeb30309ed9cf023474f17ac16d8207602f60568f51c7c15f02"
    sha256 cellar: :any,                 arm64_monterey: "9b5cb75edcb8901a317826893134bc72d53d515ed09186a780230b6afe7da17c"
    sha256 cellar: :any,                 sonoma:         "270a5e641bdd2e85161079412cfa5dfe59ddf0d84aa5da4cc3760aa7d375848b"
    sha256 cellar: :any,                 ventura:        "d482ed48b139abf5c6a4f2f7267cd656e09caf0a2ba3aa2619d26ffbbd4b19f8"
    sha256 cellar: :any,                 monterey:       "31c4ca9ed8aa2da9c7966a77285c4ef3e81ea3077e06deae1544bb2e3e47e197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f8e850f9b4d60f7757786c28a2d1106d05b72b2b05f62ef14334543b1b2abe"
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