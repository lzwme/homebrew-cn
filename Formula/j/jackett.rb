class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1915.tar.gz"
  sha256 "185df4ac7ac9a286e9dc2007cab913360b5ddbac9c0607ec3112b80edefb20d0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fc71023ec07909043ad2924091b3db7a43cb77fc3addcb41d717494272006952"
    sha256 cellar: :any,                 arm64_monterey: "ded2991e8cb95559486f7306cb1594d7b1affd548f9e48072faed12cc88ef975"
    sha256 cellar: :any,                 ventura:        "dc168b18a204361e9c1ba1033fac9735ca84030d3bd4cdc09f5d81338048998c"
    sha256 cellar: :any,                 monterey:       "5a5ecd6722d4965a3d4d9f8e205220545980bebe64a5734d6e48c4c215e95196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ed7c50c0359ffddf45f5b26884fe4b8d16205bc960d72434adb56e0d699e649"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
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
      sleep 10
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end