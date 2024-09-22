class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.656.tar.gz"
  sha256 "893579982cf5b3d777d5e94d092009bf619546d2d6a03078d3ca276fd2133af6"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "e94dd1f7b2197eccca023572c80da77432ee00df29d4bec28c90ce576e720cd8"
    sha256 cellar: :any,                 arm64_ventura: "df3968b19ac2dd4b856522f884878ea8f4e64ee97caf9599c626cc74f8105849"
    sha256 cellar: :any,                 sonoma:        "dc04d002ecf4ac574275f1a8a1a4e4d22dd1ee7ac3ba92c0ed8e4acd155bafc6"
    sha256 cellar: :any,                 ventura:       "09460b14f4e2bd5cd4e7bf362db2c8d7788970d51da914ed7d3aeed5de9c91cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40d3f890bff90f6fbd8adc12d94b114193a0ede5ac53678baef6d99a0e91c010"
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