class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.362.tar.gz"
  sha256 "353aee80f90fed1267aab541b3cd50ab781a9a53bb3ead4a4e95bc00c01d8f56"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0f0a182df729c5691ed9e05252cc0970828d3c3dbf323bfc5e3947a7295911c9"
    sha256 cellar: :any,                 arm64_ventura:  "9e84ffc55d75f4a3dc1ceb28760612de17634fdc206a01efd572a2f8ecbcbb9f"
    sha256 cellar: :any,                 arm64_monterey: "feeb8714403b0aa443d37b9fd5184f86b14fd1d530bd0879a48cc972e81ed6ea"
    sha256 cellar: :any,                 sonoma:         "c58f4669c964a5bb986d316d48001161c40fd6d7e4ec0c7277b4e10642233742"
    sha256 cellar: :any,                 ventura:        "6b276aa07e40b719e0c7f9ec845de333953ce6c399b8790fcce9509b1a3ae3aa"
    sha256 cellar: :any,                 monterey:       "f4055376126a3eb4c5fc4ab27bc423e833acbdf1a6501e0c1d32a8ecfa6347a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b4c87b81fe9a6a9084a31421106128700cf11cd78b46d1394b341597ee6a87b"
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