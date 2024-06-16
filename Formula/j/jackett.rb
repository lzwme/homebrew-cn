class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.127.tar.gz"
  sha256 "2d3e0ce2609c3f24c4c3fc0d51b7bf73b35684bcc8eedaa4ec8fe0df1963a0e2"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b26f3882f99ce01258876663e12578d0a8e1fbf5b39d1b25ff2bacb7cd2eef9"
    sha256 cellar: :any,                 arm64_ventura:  "6279cd53bc570bb49677aff87a602385781b546eca35bddcce7b9ca7f62b74eb"
    sha256 cellar: :any,                 arm64_monterey: "27253942d60e672e7a8d674bdbf178eb3d86d435930e67003f6b85657b99c92d"
    sha256 cellar: :any,                 sonoma:         "b4a733d59aeb586ec32fea4a702d9ed72552c747febf20ce56ba2882c6653c05"
    sha256 cellar: :any,                 ventura:        "298094edae44ccece0e2cfe06101f1e67a3ff1063a803c0cc218912e3aee7e50"
    sha256 cellar: :any,                 monterey:       "d3a85f9b5c0196dc9803696f48d776f05657c321f347127f7d6ed85ea4897fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c48d68d3ffe7826af67fce288c9cc6b06b91d8a006df96917f0af159381b06c"
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