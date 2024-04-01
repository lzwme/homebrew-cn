class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2232.tar.gz"
  sha256 "485c50aaa818579d650c2e9240d54f59e86b87dd5ac5814a637898b0e98186e0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20f2e75b9be8b5fb51dfcb09e30ea2ac20958740c052ffd9d39a73a3a46fc287"
    sha256 cellar: :any,                 arm64_monterey: "d09e67e0d8d25b7331de3d290c761496742a967e5384e6674c7561df37f8b382"
    sha256 cellar: :any,                 ventura:        "9e1f0bac5ff0c62a7a0a5458962a200bdd4ee09c53e91d645fe9eb455c67932c"
    sha256 cellar: :any,                 monterey:       "1f6b9f348b7a4c5a80342c73775bfca9d384940a117680575a38abdad996fd31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8fc1a638196b13e4c9c358add91e57fe72063cfef571cc75748822e44a07bb7"
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