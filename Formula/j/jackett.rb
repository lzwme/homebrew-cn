class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.164.tar.gz"
  sha256 "c57b72144c9117700889ef4194ca35a36b1d5680ec4f2f8570145c9685c716e0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5856a571ca123cda6be03700d69d98ae333b4cdbda0c7451b6eacecaab3a858"
    sha256 cellar: :any,                 arm64_ventura:  "4ba0ba37e6c5b3558264422748d94e8a64bb2216aee412b875f448070e5c93bd"
    sha256 cellar: :any,                 arm64_monterey: "29e382d6bdd9eb8324e7289d2388d002d14359b38a411abf8f9eb375cf828ffa"
    sha256 cellar: :any,                 sonoma:         "b3960f5e8f49003e2c69f5d4229fd8d58b3e7c69d116a409bc8d8f0b560363b0"
    sha256 cellar: :any,                 ventura:        "055da7d3a70d33293cf24ce7d7b37d1f23d18cf509eb82e88c4a9bb7275c86f7"
    sha256 cellar: :any,                 monterey:       "62fa76e918e54eaf1e4dfded72d23bd9cd5ded6b9e620209d53bb45355473fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c300b7d38e8fcfc791ba991fa00dfaa7dc66f133a7a35a3a17773b64d31a618"
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