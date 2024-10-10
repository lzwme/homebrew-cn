class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.749.tar.gz"
  sha256 "9428ade4daca1daa7c912d9ca32783429598c42ca443468063828329270fd6d7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dede25af33dbbf1acfb4d958c85d768bf5aee05e7bccf6d8a99338c72987f02d"
    sha256 cellar: :any,                 arm64_sonoma:  "fa6fbdcb2155ff4f97dc960df0bdd6ec6c6651689bedd04400b0bfd04e0432d3"
    sha256 cellar: :any,                 arm64_ventura: "9e56961dd2abc02ea4b63fae6ea1c8126d84d8ad0a70ca66a9101fbee8544d4d"
    sha256 cellar: :any,                 sonoma:        "b39ea65a12bcb18ef319267b06a6a7e9885f8d959b26c15f0034cc236235d897"
    sha256 cellar: :any,                 ventura:       "362a4f96c63b772f6e4157d43b4dcb811744195ae4cd89bed359e4ab428c5c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c21d8b474101414feddec3ddaa7587aa39985077bd2b86d88d36930b7a9cf7a"
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