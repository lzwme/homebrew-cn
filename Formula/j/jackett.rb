class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.508.tar.gz"
  sha256 "87e26283186ec730b8a7c96ec7d45f3aa2bdafe703d90b6f02cc33dc6018d2ac"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e3b754d83688230433830316e50a28a804399d7fb8a6c32f4cd7b75d19fcd6b8"
    sha256 cellar: :any,                 arm64_ventura:  "01f583f5abe106268154839a010d6b518dfeea7b82d9b6adade0aab33cbf5500"
    sha256 cellar: :any,                 arm64_monterey: "abe1c905f91559c9de56020977f863cd831e07c104e5b462bf11aa62adbf804b"
    sha256 cellar: :any,                 sonoma:         "47dadcbbce08deb4255d65ef6a834cb6e632a6da93fed62d6e2d3becde302fb0"
    sha256 cellar: :any,                 ventura:        "d9f5bc092a08bfc9fc48c808605c18f5e64fb9b4f245f3a9d7b62bb933b56afa"
    sha256 cellar: :any,                 monterey:       "dae3ee4ea1074479c35544739e73bce5bde2ca6bdb160d534c429913b6e01ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6d87083c9467a65fe5b9ab2f9e970c64c63fabfcb0d16163c9026dae69b7a0"
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