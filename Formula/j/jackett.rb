class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.655.tar.gz"
  sha256 "2ca6df5d263ef66f102c71d36c8c313631b757615f43a7a6c71f2edd4375cafe"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "c640ef3534e94d9c72fc1bea89ed79828f735ec2466baae58ef1c9068d090049"
    sha256 cellar: :any,                 arm64_ventura: "5ae06d9c88dec3903029ec572c48e95e4d18e46eb1dc81f9ef8e77571b521d67"
    sha256 cellar: :any,                 sonoma:        "468a30b20152f33c2c644cdc4b4539ddeb5171a4b5b15dcdfc64fbb095801aef"
    sha256 cellar: :any,                 ventura:       "df0b3e4914924f95b5c33895918e661d1398c9daa1dcad41daa051a73ff838ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9da19440658ede0610fffe84d377345b04f4ed6a75fb1f6cb49adf8136341dce"
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