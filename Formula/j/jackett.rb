class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.841.tar.gz"
  sha256 "521358a120e73c9a856ebe0e956e6ae7bf5296ed126bc61c9f29df932ced1a14"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eff1e5ac0e856479d9e2c347b0a368d6cf8c48b0c8001a15f3dd1a1fd5139011"
    sha256 cellar: :any,                 arm64_sonoma:  "9a6120b6de5f254a3591cd77965cc7598e254ffbb377397cc4a99f59c1fd5042"
    sha256 cellar: :any,                 arm64_ventura: "6e63a8ba8cfe7b80dc4a6d7ca61d4c02682a54ebdc3091e1e191f9759e94d7fa"
    sha256 cellar: :any,                 sonoma:        "80ec2f1cc68a96d3c60177cf2095e5e617bc201964294d8ba1a1acc23eb0d98a"
    sha256 cellar: :any,                 ventura:       "56ce55b0474a4131aa1068d9f2dd74cfc8bb3d2f18a5b9b5feb402d894e9c19c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "553b5f5617de3db5c6af3690f85a9266ed36278221d0f8868ad0082bad630097"
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