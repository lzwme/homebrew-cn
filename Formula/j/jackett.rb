class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1700.tar.gz"
  sha256 "5cdb46c361936ea06e2964dc1a762901beda26da8b09235925ab2a704997e634"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "072c45487e7b18b28e915fc3dc4384aeca72a6b977f05e7b76da781d3a02ad5f"
    sha256 cellar: :any,                 arm64_monterey: "3fc52e291ce0dbbfc2dc9786945f5e7eaafa346dc15fbda4c4541ce36c92b976"
    sha256 cellar: :any,                 ventura:        "f7141626b7ccc60f703e5de8c0fae1d224fb967123a383be18261821517e2ca4"
    sha256 cellar: :any,                 monterey:       "ebf49b10d14c71fdbd8f80f7d9fcb4bd171d4db112518e1c1f27cfc10d564b56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a57c87aa2b84256523e0904332c9e166411d4e2543b9cbb972de7109a839d45"
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