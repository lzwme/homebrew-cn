class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.188.tar.gz"
  sha256 "42e5a6f240db242a41d854d39e2ebf8f4ce88150e21fc81aab76b3ea9552949c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a388de8de8815ec81bb622748615717157958d902c9d126edb798a2608b15fb"
    sha256 cellar: :any,                 arm64_ventura:  "c66548b00c452159aa30ab60fa63c9723a388de079fbf0426ce562a2db36c527"
    sha256 cellar: :any,                 arm64_monterey: "f86180271598f0922ed54094e461d152550f8e76a4d54430f184d6beb089aecc"
    sha256 cellar: :any,                 sonoma:         "8846fb1223126cf820fd82388ff8907aa607bbfd5a662cbd234141b3a72a6fa8"
    sha256 cellar: :any,                 ventura:        "55b4116fdb40588247f99bd77240a299770e136edd3a8a51dd259bcd387abfcd"
    sha256 cellar: :any,                 monterey:       "dabb23d341a0bbc10ba33e37c7a7f13ae8b7a955485fac8cb9c100e10f578a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dbbb09eb0c7d67d5dc35543231aa89a7c15b573992caa5224db575bda96af77"
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