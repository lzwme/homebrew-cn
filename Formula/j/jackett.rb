class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1454.tar.gz"
  sha256 "a651a032032c1aef76fd0122e770212c0ed9b7919e461c2cbf0d0c9f37260646"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11e1f77597fbc07c7bc8df5355985f8e89debfb4eaeb43f5bc8aa6d73b6e8875"
    sha256 cellar: :any,                 arm64_monterey: "fdb93196d068dded349f20e01e248c7668f9789b5f059a858d06fe89ed07de55"
    sha256 cellar: :any,                 ventura:        "eb031e6b3b11791302cf826e13bfa6f0bd73b8d9ba07cb4aae0db4b074cd6e94"
    sha256 cellar: :any,                 monterey:       "2efe54733322c709c47be4241f1e9d93a2521d2c739130968a8c9b8868c2bd1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c5e61d2019a5135a278da2a4574bd4d3b26f6acaab5cfc2468e7bca0593355c"
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