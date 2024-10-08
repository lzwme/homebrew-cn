class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.722.tar.gz"
  sha256 "662c1cb31591ebb52ddaeed550078c908c209565ed30ab6c0893d7261a0918bb"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "640ef8ea9cfa5061c163192da5c531ed47b8044e2ab6c7e9ef3c9a712f5cd74f"
    sha256 cellar: :any,                 arm64_sonoma:  "5f51d5f8461364cbcbc2a9fb3bfcbb4d47d85a99ca412e477b721157298d0645"
    sha256 cellar: :any,                 arm64_ventura: "60c28f5e1198eab321a94db8bc46a37f1ada4fa3cb10d75bf0c9d8c2aae5b9d7"
    sha256 cellar: :any,                 sonoma:        "a7121ac54f02c74a40d5c82877cfa7d9fb7172538a8ab880b112e0beb7e08364"
    sha256 cellar: :any,                 ventura:       "f01b1a7f05f6a6745ab502b2b963295fa1e99bdc59b4a0a665f217a8819bda2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9635bf23a684819f1ab7c5ac4f8968677dec3e38d5bd853795e50cbb112f9536"
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