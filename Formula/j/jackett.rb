class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.179.tar.gz"
  sha256 "2c2612628f3d4a395346a925e7106d89541a3e9d83c29f91a48a8a0a7e70a5a7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b2b4c2676d7b5a1544dd170ec95788bc1acb596a1794cd27a998fe579f2dced"
    sha256 cellar: :any,                 arm64_ventura:  "2b9ec1aa446c702c8774c15ab62627078253f1cb5e2c4cca1b97d526f3d8d73f"
    sha256 cellar: :any,                 arm64_monterey: "c132fd8d91417e7cf322eb6d106e90bf6cccf5bf46e57b852aa085b534720f5d"
    sha256 cellar: :any,                 sonoma:         "1a9168f5eda4310fbaaae5432b06bd705655c85670d51d7d9fac12f50cef1b31"
    sha256 cellar: :any,                 ventura:        "7c61aa689f93883bdac7aa899a071914b10413e89eaf2b4332dc1dc1a8d42edf"
    sha256 cellar: :any,                 monterey:       "83e327c67089ed446d4e5816bd79eae12bc88f6addfe6b99a6aef3c80a6f8238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b722784ad55751d8620781049182be77b2b738330a718c7c6b4ca7463376e77"
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