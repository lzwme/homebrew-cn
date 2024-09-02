class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.545.tar.gz"
  sha256 "24afabbc12518ddfd673e2cd03d9e151d35a60dbdd143e14e81cf9b574239c16"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bf1445e2ca6258f62417a08a4df5b8db8b02fb13e392ededf3358e0d363b920f"
    sha256 cellar: :any,                 arm64_ventura:  "0193d3c5dcf7354c9ac990fee646d7799abd1af0c85bbff9101156c10c1d9298"
    sha256 cellar: :any,                 arm64_monterey: "f2ba0b729de3a9a8a1ed47de871c92ffffdae29fa386f11a1a30d916e5d1dd7c"
    sha256 cellar: :any,                 sonoma:         "0efda58e0935c2b91a7eda0f631631abed92e48481aa9c8edeeac3cf2d800710"
    sha256 cellar: :any,                 ventura:        "7106c656049daae52fe2f4bc95c690d88f8c9b83e8454b51ed3b6f9dc7790ed9"
    sha256 cellar: :any,                 monterey:       "7350ac88dd5bf7c84f72cd32dd31eab0e2700975f5cb7b0d0289406679191dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c53fbb02025264e0f8f3dfd9efdc1528ec30dea81207a013f2f5c06c319cc7"
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