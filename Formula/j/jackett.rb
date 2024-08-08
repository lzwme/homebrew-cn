class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.416.tar.gz"
  sha256 "5c1c3ed964fc792c231b3318bd2e51cd598bcc45804f0784b9207c4598c36ce6"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fcaedfac124892cd0a939dbb06d03c49e6a7053c107095a462c879ae2564c8a6"
    sha256 cellar: :any,                 arm64_ventura:  "e7b10731f41356b5f93b3051d5bae6523ebfcafb82608794267a38435c9751a9"
    sha256 cellar: :any,                 arm64_monterey: "a536987ad9fc8912348ffc40ed01fc468e9e2d1f4b9ea6c584a4b92e15ba5788"
    sha256 cellar: :any,                 sonoma:         "dcedb3077e2dcd904516362cd104bcaf330aecf3510d9c53f812f7cc56c403a9"
    sha256 cellar: :any,                 ventura:        "17482184e6dee261b08d57a0edb9b5742d6eb2ed8f5aef5fbeae43ef1d81f3f9"
    sha256 cellar: :any,                 monterey:       "ec3552824cb8f30b2882d34f3028fba2b8df35451a0e84ae5f159ae6c9e8fe1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ad6f6304a7ebacee3042b7cb0631940cf2cb6221e8866fd21f5704abe9474d3"
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