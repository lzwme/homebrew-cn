class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.353.tar.gz"
  sha256 "8e914bda197fab1d9498282444809d197f81004bcaa5c8baf41bcfb968fe4c25"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c0f25fad5df5180d3d43e4a19ee52e27a5a96d6739c86f85c3c339df48949dc"
    sha256 cellar: :any,                 arm64_ventura:  "381075b7eb1b2bbf841eae6b5766c947f5df0334e5f291eff04c7aa027f12707"
    sha256 cellar: :any,                 arm64_monterey: "b458d1be4cc6c6c4099920c3444494d4d860f272ff09b4fb89408383d4dde87e"
    sha256 cellar: :any,                 sonoma:         "770b989f3dd2b58e336b85d34914f4af33910a4fcb851cc2e1b54276217292ef"
    sha256 cellar: :any,                 ventura:        "3871be153049c2f0a572be020c5fddc04e1cd07b682d9ccec43fe1bd6e459a1b"
    sha256 cellar: :any,                 monterey:       "4fd5723db639180fb73fc5fcf23d6f706461430b6dcda12f5006e777898b0607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "285307c0fa05cd9d290c418d85259342b7afd75452b8c34424258d3e530321da"
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