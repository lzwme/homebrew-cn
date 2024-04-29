class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2496.tar.gz"
  sha256 "7f932e87c5e68c146061ccd55ae125772959132616655f6012a8544b2e84ab9d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2749416acfed17b330a9f54c9b7cb1035f4842f09704ad30f20649107d1a879"
    sha256 cellar: :any,                 arm64_monterey: "e000ab9e38f0a749301404b30046e31150401c8abe0acf593de043584f96dab3"
    sha256 cellar: :any,                 ventura:        "28597de0065082a307f42de7507bd12465741cd27bc2167e24ca3f965649d9e8"
    sha256 cellar: :any,                 monterey:       "49240ccfe3a5d8db9fbde713252b83ff37a3d12773582d32307426e683deb727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "140e4c9b5ff2490a57e77f1e2e82a5b2ec4ccb651e47ab2c7e2ccbe6db2c6d88"
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
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end