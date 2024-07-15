class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.328.tar.gz"
  sha256 "ce41e58e22d7eb29fdca04b4fe5e68e167edff90fd33e1168ec1cafe9d6cc935"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "25d38597bf685232997071e4f07d1f68cb9ec49dcc5499f67542ceb42865e366"
    sha256 cellar: :any,                 arm64_ventura:  "8501e548de78d47dfcce93f7dc5dbc4de1006941f071804c5f783f299c2cdfe8"
    sha256 cellar: :any,                 arm64_monterey: "afea38cc38fae87d25857fd83cdc3db771bde7702537598822a4e77317ce1e3a"
    sha256 cellar: :any,                 sonoma:         "4ffa94296c833c5e39a0209caa798d3c06e93040eee14eb2cc2e0b1d6436ab67"
    sha256 cellar: :any,                 ventura:        "f24ca071236a458f91e82b85a17b14b8be9564b82f2601c017772193c00d79ec"
    sha256 cellar: :any,                 monterey:       "e2f92f50b49a0fe4bba970c19da56172d528de0f170e3b0433d150c6fb37b7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bab854c75b5a2ac6e6b87d66a2ff743954fd6f58f354b9b9e24256fa7a80544"
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