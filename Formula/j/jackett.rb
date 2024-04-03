class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2258.tar.gz"
  sha256 "6947ec681a5ca26e05e4437ef93f810115cda89e884a6bb52d9e88d6cf3cb2cb"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af27d26c87a5295d3cc1305dfc33d40564bc8764daacdca1a7d4df95ff8c3134"
    sha256 cellar: :any,                 arm64_monterey: "6832d0fbc2a5b7735f2a96383ada694baf91ced52b4166eb996ca0d83a4fbe93"
    sha256 cellar: :any,                 ventura:        "5cc6832b91cd83dcdca11722ef58c8b1696e0436509a0c40fe1caf1ffbf624bd"
    sha256 cellar: :any,                 monterey:       "876da8151937b6fbc4c10c88fd933473c43476a99629e84b56f5bf1497be07fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f4877773dd513e92b043910d1edd4a310b69789e03f8f66ca7155c1d54e911b"
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