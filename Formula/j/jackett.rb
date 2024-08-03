class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.402.tar.gz"
  sha256 "64db64085dae18a76cc8ff7b9fde7629236efcc994a3c59736130bdd30c06dea"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e71c3b95670d09ff12ec5b6c95aa34064ae1f904c92e956bd5c704147a3cae26"
    sha256 cellar: :any,                 arm64_ventura:  "a13249b6ad94aff4fc0f0540604aa05b75d207ed0e64822aba4357d149331dc3"
    sha256 cellar: :any,                 arm64_monterey: "a71b512014ea71f1b59f81d1492980632cdc05dc862e3c7b95d52efc14dbefbf"
    sha256 cellar: :any,                 sonoma:         "dec3d05b19ffdaa7584f4a330f40fcd610f4d23612f8422c6b404aa4f22b2a98"
    sha256 cellar: :any,                 ventura:        "b0493143de2b317fb49b357309b713b41993d4001bf329b575b4433e54c34c5a"
    sha256 cellar: :any,                 monterey:       "02193ff96c141ba34f9e137eceea281381aefd5aba31e1e1306d13740cd7d3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e47987ab04f644a1fdba94d4c1ac60dccd3ac0ea52e7f7b23be376c3925c0a6"
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