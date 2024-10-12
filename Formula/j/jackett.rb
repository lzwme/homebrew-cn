class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.763.tar.gz"
  sha256 "80368fb98f321ba690dd40965c44553c9c24bfbc2f34cd3c6d60781a3afe9d9e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc9a32892f41a6d7b88a72390a0c5f4f8fb1bac34bafc4b5b81c33b17e066049"
    sha256 cellar: :any,                 arm64_sonoma:  "853931c8da3698a56aa973fe2ab7ffdc37f1f2cc16991d6d330b7dd396031aa7"
    sha256 cellar: :any,                 arm64_ventura: "ed690bbcc4645a57c2a94340c5ea35de07fd3c32193d181203603b6761e8885a"
    sha256 cellar: :any,                 sonoma:        "06f33f55aa1647a6c4297ab7a48ec5a2d4fe0d2d6cb055ba989845ba564cc098"
    sha256 cellar: :any,                 ventura:       "bc105c6cb6a7599454f0fcce091a3c5b705820d7d39866fd8c8a93483dc7d78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d471bf1eca3d20084568d2fb2de632931c25c6273251436f2994f3f73a0461d2"
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