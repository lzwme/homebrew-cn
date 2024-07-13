class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.320.tar.gz"
  sha256 "efd939b47665ab3f9119ab87ccf5b7403edf5eaceb4832656348ad6b2b916070"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d75fade8e28b240590c55fa0ff89de836203e11c3b5ef47a78001b1be5eebc6a"
    sha256 cellar: :any,                 arm64_ventura:  "621c43d9fb158bf06ce4951147d3088513d55f97403e72cd234fc2d40ea45c14"
    sha256 cellar: :any,                 arm64_monterey: "761c8b8c42d4240ef2a9bdbf6cd1098dd5dee400b48129af9f53e4253f9e9e17"
    sha256 cellar: :any,                 sonoma:         "8466f29aefe3822ab4488b116d9c6a9153cbb32b2f2dd04905f9340b095d8089"
    sha256 cellar: :any,                 ventura:        "bf2630d68fd3a8d0a45097ed2c63aa97d3867304d941f0363366e21f597e0fa1"
    sha256 cellar: :any,                 monterey:       "edf31fd5af7eb76729f34b09ae9dbaf2ea0bee44a17942a64fe76257aeca9984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "039c755432566ef5788fb5d97248e3f98477dff519f5f1b8b10d4bb69b62c034"
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