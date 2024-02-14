class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1738.tar.gz"
  sha256 "d1e21a0a6e144890172545a32965b16bcce60161cddc3dec93ec4866a8f9a10f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4be9688629e2ba36844ade024434d228879024bf99140f2463062dc77a8b52d9"
    sha256 cellar: :any,                 arm64_monterey: "bc437712489d0b4b2e9d4e2fbd3961c0ce1ae8ae434f0c8586a8542ddcda4e27"
    sha256 cellar: :any,                 ventura:        "068b2267adc7663013f69446d1ec182846cc5f2a0ab213bc0028e00e35b01b11"
    sha256 cellar: :any,                 monterey:       "a1b4724bc26dee4d43c39fcbc184dad6ffba4d3f950c1011f67ee7db4fe82bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d1ea4e32ab3435a4d972dabab40bf952a9b5c1b9598d808c41e15cc075c4437"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
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
      sleep 10
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end