class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.311.tar.gz"
  sha256 "746c45b0390f5dda10c40fcd92df320cf1b0ee3d14e7d5d95483dfac7f793b24"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c7f904115e7022430b02b5695b56343fb6e00ac6b91101fe7536b9ee9485556"
    sha256 cellar: :any,                 arm64_ventura:  "dab5791977c530a71d13b74c31946216ef815f44b2b75c2544b1993ec0fff938"
    sha256 cellar: :any,                 arm64_monterey: "d1e7c08b0233f73796a692be746e2a71ceeb27e118abf185dc3150f83aad3c12"
    sha256 cellar: :any,                 sonoma:         "2bbea1401f0998634a18ba301502f1110890d3be598da8aebdd74c8129d223aa"
    sha256 cellar: :any,                 ventura:        "deba37cc1d9f85600d8cc3a2f051954a1d96cda6dc6c8675d9d9945227f9b432"
    sha256 cellar: :any,                 monterey:       "19f98f5545a3695d2bcc5932c38d1df50f075b061360a0972bfcb9396d1abf00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fd4b1f52ff97612e5edc1964c545ffb6ce39c6dd5c2049d4a8231d3477f8ace"
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