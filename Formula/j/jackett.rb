class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.850.tar.gz"
  sha256 "89d50c47092ea9a712a5e0596092a8e516cfdf76b71cc4b2b5b067af4c093867"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "81a2a66fb6e35eb32866404116ad0fc2c795f9d030853ba7928f43d9155b5fcf"
    sha256 cellar: :any,                 arm64_sonoma:  "31f0eedf94906046fd94759edcf076f17171ca79f23225c7f604e7301e17cb7e"
    sha256 cellar: :any,                 arm64_ventura: "ee3cd32329b43690ddbf0d9f4169c122586e70bf7745be3fe3cce134e7057710"
    sha256 cellar: :any,                 sonoma:        "20ba5322d4f24be57e454041e6a8b04b553fb24e4dd7192ce7f9dbe7295ae70e"
    sha256 cellar: :any,                 ventura:       "38f1be2f556509c6fa94dc827cf7350d770ca8fcbd56c4192114db970602557a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f232ea2f422d233f7e0b1e628f25770015786e3112fa1a59d7b51ff07da7cf76"
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