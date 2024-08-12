class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.436.tar.gz"
  sha256 "2cd4c10b5cd710301b1b03cda7c020b7cee973d4a280eb319248accbe4b67f2f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "397cb3818aab136e4cfc628e13edae0b1bf2344331970b22def47ece77dd0549"
    sha256 cellar: :any,                 arm64_ventura:  "c2ef89ec4a18f85ee66865091357abd35687005f5027a0535aa610c41c74b5e7"
    sha256 cellar: :any,                 arm64_monterey: "7bf7cadd099ce3f9581d83ce33f4325361278733767b7e4d4e378dd6fc5254ab"
    sha256 cellar: :any,                 sonoma:         "b1123655e6d3bcd27843fe4a92771957cb6d7c66f90bde1ffe8154b9e3e36a34"
    sha256 cellar: :any,                 ventura:        "416b002ca3b763b4ab6b92d548e69713b53462caadc9fbf5a53fa42a828e3876"
    sha256 cellar: :any,                 monterey:       "471beb8d7a9e2a3df9c140416eada53d88e4ae927f8249ec40d2de355dee9113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b21d5e5e2ec910dbad9d6dcdd2bb6800bf91e0edb8b5bbfe163a63e35cfa7a"
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