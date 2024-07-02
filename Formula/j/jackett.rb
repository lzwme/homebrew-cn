class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.260.tar.gz"
  sha256 "4987a84204eb649e5bb8f05b077a9ca96d4df5a385fc012676795be7f53aa236"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bd29f54f2b41e3a1de6e66b4665b37469ef55e6eabd30e8359eaaa3a2693d3c2"
    sha256 cellar: :any,                 arm64_ventura:  "c264c393e1179534dddf293789538cf2a6811f5af96ed856cf5c2bf23c78b841"
    sha256 cellar: :any,                 arm64_monterey: "f1460d615fc7f895a13e2f4fbe965ecb603e6a1a065f9c11fd26afdc5f4e9587"
    sha256 cellar: :any,                 sonoma:         "09b2790ab3b3effd394aa07e3add9a3a97b28722f4103d0cb175461b95e62ad7"
    sha256 cellar: :any,                 ventura:        "4a82fe153145cd9be7fc9df822c5463ffcceb979b90da223bebbbb7603b65285"
    sha256 cellar: :any,                 monterey:       "5c80e4e373e8fe6add1a1122cf978ac4cba08e3985b9ae1b8a173739f24b0f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57fef4bb0809ce6aa9419bf73689fc2d86c6bd7641a304b93306e5a2a3762859"
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