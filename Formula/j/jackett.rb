class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.263.tar.gz"
  sha256 "4e8aab6baacf2d676a48bd5d30dda70ebc5173d8097e61745281ba3a41d7f2c7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c184479f2220fe842020d97695ea78fa5864ae67f4586a8344010c9fee640576"
    sha256 cellar: :any,                 arm64_ventura:  "1991af2e74efc76244de3276e0fe9e6b40cb921f45a59aed3d3943d34cac2ad8"
    sha256 cellar: :any,                 arm64_monterey: "5b44ead578270ef6cd9d788834fae40f78c2a7c70786a1ca8f62d27c2a8756eb"
    sha256 cellar: :any,                 sonoma:         "2e97003773c3c983df28a1ad3a7de929ab6b4122a1c4f2d10a78dbb12bd4d4f1"
    sha256 cellar: :any,                 ventura:        "399a3541177ec558fbd079757cb5400643a20453153aeee16ae5e74ce702e945"
    sha256 cellar: :any,                 monterey:       "026f6a91a3f19011de945fd1c4b3f51effe547e6ec10ce63cde7f44a9425543a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a45990457ac6bea422202b77e47bf41633f131c0f7c5c636878b98b5df4a74b6"
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