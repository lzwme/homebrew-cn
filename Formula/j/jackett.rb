class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1650.tar.gz"
  sha256 "dc45c362378550182f42b01ee229a4ef76615347a4b3efe25a26ff3bd32e3e36"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "905e6c6e594e708e241d4b354dc4ee14e2095e44ccfe03a84c34f7864e0eaff4"
    sha256 cellar: :any,                 arm64_monterey: "f9ce5f4efd1f186a6dec807176878c209c3e4083111bb58a6779357f47b1c725"
    sha256 cellar: :any,                 ventura:        "e59c4836c9f5a43ba693d077b636f40c6599e7a9da5c11d96521f6709382eae2"
    sha256 cellar: :any,                 monterey:       "69be7f72d71bc495ae07870b8490595b81f2efb2854c77b70093031f82ac52db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28f6c3175f4e869077eb354d96eedcc8b87b3b58d34d0a0bc8f00e142c52bd5"
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