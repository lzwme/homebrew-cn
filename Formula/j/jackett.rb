class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.688.tar.gz"
  sha256 "d0d8c6447c628583ed57cfc94ea9f2c654331fe7209e965b4be90f4d7ec1c271"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe329d449624648524a9e2d86b4632d0871adbd32e6b9dca6286bfc64fff39a3"
    sha256 cellar: :any,                 arm64_sonoma:  "14d3724d6560e4e16b692086e45fde4988d4a25a166c2e657982bb403b643f3b"
    sha256 cellar: :any,                 arm64_ventura: "8ce456040d618c9388795b8d571099b05a805588aa0b0a15c50508f6e720b6c9"
    sha256 cellar: :any,                 sonoma:        "e050a12f49591c657bb42517946b5052e835730e97f063337043aa5c18f012b3"
    sha256 cellar: :any,                 ventura:       "e6b18bb73ec28e4e398941d35ccf8158b9fac747e7395ac86e18ea7bf92a2568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81f8001e671aa77fb13353b4a84e007964ae80e255ba72d26c0e7deafd31678a"
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