class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.716.tar.gz"
  sha256 "70d9ddbe78b57e7a649628d90bb08e73e2a29790b7e483e61a06f3640081c6a2"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed9edd3d57599e83d72721382c505b7d596c9a12f2fcb84c6a3a0f2798110ecf"
    sha256 cellar: :any,                 arm64_sonoma:  "02629d0895469a2ecf872654faceeafa18d0b9ec570a89c4b5c55614c06f66db"
    sha256 cellar: :any,                 arm64_ventura: "d56e86c9d267a61f041e97daf41d33760937b2a7114fbcfcd9993877dd36784a"
    sha256 cellar: :any,                 sonoma:        "0b8aae472d702a4e00059889d07200991d6b96e5c0a9de54007e3a69d26c6f77"
    sha256 cellar: :any,                 ventura:       "73016c32e5390a3022c6cf0fe8dfb2e5ae7b72b8d9600f0a50440fbc42f4c5d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49594df6ee7154341326c87126cec6e3da788d717a3bdaea4a9cc0269dbc4e6a"
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