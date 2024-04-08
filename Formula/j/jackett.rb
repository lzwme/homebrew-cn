class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2313.tar.gz"
  sha256 "af55011257805c7c75ac4b9dac40447193257a1dace90d321f4c35f1151abbf4"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e5e6e34e1db78a88d87bc937a5079fae9e197d52aa9f1199190fe0943085dce1"
    sha256 cellar: :any,                 arm64_monterey: "706e8fb426a47937d6d2fb1916d3fee2e769bc4a6eee795b69d4fa640b486a0f"
    sha256 cellar: :any,                 ventura:        "328f294795bd54b83b58538b72cf3d947a24fc5a7e290e26cc81be02a15ed062"
    sha256 cellar: :any,                 monterey:       "4af878c55e483cce874d4838dc56afece58b63b5d8442c5f7e23c01139ce814c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df09cc2e5aa267c23f47124fe818801c8d1283cd034e8760e8c2ec2f76fa5500"
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
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end