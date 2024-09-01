class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.540.tar.gz"
  sha256 "694f16f1b5f356b7b25161bb5cad354566acdfa6d8a39a733861611c54f913e0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6ea6ecdac332c0ac3408ec0f3784d752d8aa80fb5651cfcd98f538cbc902955"
    sha256 cellar: :any,                 arm64_ventura:  "28ce254ad4be2eca498a0ea72bfe7d14035a3141cc529714f8c717eafcaf546d"
    sha256 cellar: :any,                 arm64_monterey: "1c5bd8d40e68f95dd0573b9e5576e93084f9793f3562a818b2ed56fd5ea4a107"
    sha256 cellar: :any,                 sonoma:         "11804077b2747dbf45fabd5a417b408962263f6b9f80cada719be9899eeee19e"
    sha256 cellar: :any,                 ventura:        "ae9750445aa4ab4135f96f5ec410892009b59abab16d83ca79769b23e98e14c0"
    sha256 cellar: :any,                 monterey:       "30dc3ab743e8bde19dcab029408b752f14cb859773fbdbbf09edb6248ea2ca4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f810730fa3f7662dba67ca44dbcde530ddd09bad7bbaa5f2a2daa6f0ad92e6d"
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