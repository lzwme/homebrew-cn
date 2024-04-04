class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2265.tar.gz"
  sha256 "5198b2a9f6697acd72ca14f50bc79015efe9b3fded7d246d77dcdf968ceb6a02"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b980bd97aecdd6a3a984c2b62541bef1df16399336e1cf9024a2bb9164d6ce1"
    sha256 cellar: :any,                 arm64_monterey: "04dab0b35dfcb9f1c75cb342db5efbdcdb71b69aa689f786bef2a013ba1618a6"
    sha256 cellar: :any,                 ventura:        "6aed9ae4cc70cc5d45661fad8f27416ff5d25f34f28661539663b4ac7af59797"
    sha256 cellar: :any,                 monterey:       "e27ac9b32619b04d0ad4b127a0dbe96f14b5c5a869a7bcac339b997154d9a606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a681d96ec45cdf593405239dbe28352f00cac366a76527efd476ad3736a5bfe5"
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