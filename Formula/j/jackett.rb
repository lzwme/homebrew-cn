class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.189.tar.gz"
  sha256 "dda792868984ef18c8fd720ddf4fa7beda52b21ab0f0597b623be4cb36d2da63"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1bc3246a64b74a4597152141b755c7c2a15a134c7d7cb3c38051952294ea5d5d"
    sha256 cellar: :any,                 arm64_ventura:  "0eff0fc063c3da300141e2fe2c62d7b3156e90e520353ea87da49d37d12c567b"
    sha256 cellar: :any,                 arm64_monterey: "25fb821060b331c0220bac569eab856477727c68b291946210638d37ca393d41"
    sha256 cellar: :any,                 sonoma:         "2173b067d0f442d592169fb2526924afeb11bee80975865ec973ebe15360ed11"
    sha256 cellar: :any,                 ventura:        "4b9ac1fe5f86274cd1ec6e9ebeb6131e36b7f6e58bef27a832b9165b6a371ea2"
    sha256 cellar: :any,                 monterey:       "950f699836c65ae213a3c23fdf9beec8de7b63dd0d68ecf5690340ced089e846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85f79b7f311a28474cdf6a6a109c0cb63a8945b24abeede3a17ac95a54678f2e"
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