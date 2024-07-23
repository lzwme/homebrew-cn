class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.360.tar.gz"
  sha256 "394c35973ea2c015de91079f72b77cacad08b044809c1c148c17f98a867575a8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1254ea494d1fef003baf41c83f4563bcf0474480a8e509a54f2955db22ae479c"
    sha256 cellar: :any,                 arm64_ventura:  "80e8829cacb437ababc7edb4215c5ad2dfc5e3ea18e145ffb94fa35405ff748d"
    sha256 cellar: :any,                 arm64_monterey: "8dfff1be63e354afc64f8c8a1d7b80addcd6efda3d3d3f69fb2a5b75529ecd60"
    sha256 cellar: :any,                 sonoma:         "f6e3996d2c8926b6a47775ef97e8e406e48483f44ac4ea4b3f2cbb137c072b70"
    sha256 cellar: :any,                 ventura:        "9de429203ed5f57b52dd8ce12e162421998f0b1021618a390db72148760236a7"
    sha256 cellar: :any,                 monterey:       "64e7caf92596d13a06a677c524d7cfd51b20e2fb09b9d31eb28a70b3236d8725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3e53c99326945b9c1238f87680caf9dbb720dbfcf2ef2ea575b27587140deb5"
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