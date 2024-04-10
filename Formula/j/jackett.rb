class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2329.tar.gz"
  sha256 "ecc81e3c150f942a8d7d0f4a848297e3406e9887eaf633878f6cf60173d5992b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "55cf41f256b766d97c61d5677d5a5089a89b0d2a7caefa15a5aa0e63bda66d81"
    sha256 cellar: :any,                 arm64_monterey: "0b42fa1bfd1dca1a891007526f389ae7bc877f288b2e5fc0efd450f21f9b1e90"
    sha256 cellar: :any,                 ventura:        "f287302e55b599a78beede8b1ec869681bc0d572249f2f1189245c64bd8721d1"
    sha256 cellar: :any,                 monterey:       "9cdb2bc38798d6e7499fe74c45da217e5178961acf8752b33255dc72e1b662d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a944d6be9688564674397b94cf3abfd9a3cbc6ef9ba86bd97506dd3ddbf59ce6"
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