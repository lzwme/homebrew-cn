class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1835.tar.gz"
  sha256 "b07fe0864f97bb1d6e26dae67732fcf28fe8c356ff651cdb11e14f867659e84c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9619d06d9d0abab4c44894a521717a96a3dc510219a2334e42eb726794912594"
    sha256 cellar: :any,                 arm64_monterey: "4a66f6e5c972512182d546c34c6209cf3c50eda7ced0b589022e3ab01f8ebc14"
    sha256 cellar: :any,                 ventura:        "287a2d220669ea7aa13f428f7e13430a41bf3f7dea601bcdc682b5bb34883716"
    sha256 cellar: :any,                 monterey:       "7072636ad453806d26f01124693515d9a575a812bb5922f6a05139d2740dfbdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "000d7e099cc9f56593a48f40f0422a6c26b8d343e4cddf1873991d9df96ca4b0"
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