class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.315.tar.gz"
  sha256 "c94d182dd7fb32c941923cd8097de94a705d661bbb42d46dfcce4a06e251860e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e801445476aca45027bc9503f64128544f36e1321982d50053bafb0be1a0af9e"
    sha256 cellar: :any,                 arm64_ventura:  "18d9bbf47c84d62bb1ffa9cbf5bdfe726451a4ed528006682e11be714ace043a"
    sha256 cellar: :any,                 arm64_monterey: "9e0db9f4919c17b153d0a007041661ae845a3c5b08b3c291088db1a14ce3bb7c"
    sha256 cellar: :any,                 sonoma:         "42f11d1ee6a9c40b5a29787978a415edfcdc0fb91df8daf05ad77ac85b0573ef"
    sha256 cellar: :any,                 ventura:        "c0d529863a90b862cca337460c229f5841403fe03f3b07149dc51ff5ae6f96e6"
    sha256 cellar: :any,                 monterey:       "80f2adc867e9fd570f64e62cb8ad1ed62b9481ac981579e7ca5074c0d8e02231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3bd3405b963443b8a683571b348a8befa2e592a752981d9aabeeeb26222268b"
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