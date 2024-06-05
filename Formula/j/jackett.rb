class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.58.tar.gz"
  sha256 "d4411f2ce3f4c8e119e4ff795927aa89be92dae2e83dfa7bffeb255e2a143ead"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81f8b49faf7024726c87a87faeaad7041c5488401d3dcceff91e39a5ed632fbe"
    sha256 cellar: :any,                 arm64_ventura:  "86492f72fb5b89a9b49c2897535eb55f9def4c75f047761b8ae2ee533af2d874"
    sha256 cellar: :any,                 arm64_monterey: "39d486a8a700dc279a80a3d37c6cd3798ec2a4d4a78a6e3ad27ba9c100ae531d"
    sha256 cellar: :any,                 sonoma:         "48c4fb329210102b77b91973efc557c8a1c81c82cb0c22cf6fd78934a097fa75"
    sha256 cellar: :any,                 ventura:        "7dd795a080810f6b0553815bb0998bb143e68674afad5c519a81a624752983e9"
    sha256 cellar: :any,                 monterey:       "14c029521d352b33f3589672b55d37e2af9bf324d6d57bc178d2322d94c4b26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bba1c817c866811f57f688a62ba569fa60b1eb2cf4ddc815655ff568c05787fc"
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