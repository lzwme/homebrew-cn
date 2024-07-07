class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.281.tar.gz"
  sha256 "dc8e3e14d0a39f97605737388518fdbede13bca853c158b32f5c363bdf8e152c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "47f67f41d7a85208cc3a673791420528634077b8490f6d850c3fe2064b267b07"
    sha256 cellar: :any,                 arm64_ventura:  "68a70cd484c058e5964dbbc3667e2a6588a855ba420e9d80cb6f9921232aa1fb"
    sha256 cellar: :any,                 arm64_monterey: "b1018f2ca79ccfdf909fa5ac2308125d5dfffeb1f2a4660fd232cd69967d09e0"
    sha256 cellar: :any,                 sonoma:         "6f96198ce7d82a9ced39d7c24402ce171da86e85a643e08c637382770e60543f"
    sha256 cellar: :any,                 ventura:        "e848162280eb86fd36b978a9ae16ad1851685fc6f3070798fc2d08592996e5c6"
    sha256 cellar: :any,                 monterey:       "74d0526c036718b66a3e7207372c320318e2b4cd87078737221b20ba99fb899d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e16853c3f0e1e46654181dce9170107cf24cd5158ff8c134e4bd09202df0a359"
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