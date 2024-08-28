class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.526.tar.gz"
  sha256 "6608e5fcfa350393727a61d35577c8d429fec6afc1e5e71fbb37c4a3600235d2"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2144edbbaabab4619426a470320de24d6f8b038dff7662d88a758efc558808f1"
    sha256 cellar: :any,                 arm64_ventura:  "a115c5f591b21be3efeb185d30da7005fc27436fa4c679f139f42815336e586d"
    sha256 cellar: :any,                 arm64_monterey: "041f27efe6abe66f34b80256ac5345815d85c186e9d442f3c986bb3b1bdce6d4"
    sha256 cellar: :any,                 sonoma:         "80987b5c8d2eb3376e4fc158b8bba7a31ff15a0dbe8e96d5251d993dbba7afed"
    sha256 cellar: :any,                 ventura:        "b089e048b6e5b6b2987b8ba6a0811be9d8e47658609739e9875af374a7a2311a"
    sha256 cellar: :any,                 monterey:       "b65f422e0fc85f65bbcde0ab8df42cf529a3fc2a92eeba258106250e43ffe6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c9eddd2b24d94803e99a97df85bf96f2624090f4a247168b59407fab717834"
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