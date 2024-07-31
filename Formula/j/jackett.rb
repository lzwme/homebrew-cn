class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.393.tar.gz"
  sha256 "c724f03fe76ac950c9c602e8151c9bf0012c4a424e2091500c047f1361b458f7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abfae3930eff4f77484aa95191b43452dd35107c1185ed2e9f7d839cb6dfb3d4"
    sha256 cellar: :any,                 arm64_ventura:  "ace17afb4ce5c4ad5e90f07ea62b0d1ffda7bffb0f01b521208229170316ad72"
    sha256 cellar: :any,                 arm64_monterey: "eee4d079c67a566e0cfc1182dca391d0096019cd50657ef5ce285c5cd4129e9b"
    sha256 cellar: :any,                 sonoma:         "508a6e8662e34b661a68a515e54bb241775c1bbddf0fec5c31a83f5ed72ab2e9"
    sha256 cellar: :any,                 ventura:        "a2176d80ab5875b5a8cfb1767e3225a8522c5ed9541ce2bda993f2fbf8c20933"
    sha256 cellar: :any,                 monterey:       "1654319cd94d711b8804dbd99cb48a7e26b1781ea30d0ee4482f3d51ca6b5e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e71fa1234a89e87fd54e57018144df7a69851c66ae59eefa9422e511819782b0"
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