class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2284.tar.gz"
  sha256 "c0b5c7b17cd50fe60030eca7e8921f1d46649ebaa06b4319dbff63fd55a11db7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6810a72992e8b533aa53b5aa0521ca30fe88746030e3ad3b871d4d0d807e2933"
    sha256 cellar: :any,                 arm64_monterey: "7603e3fbe9495f7c2c1996193ff58ce265af26606a852eab6b9b6a8cb3ae4411"
    sha256 cellar: :any,                 ventura:        "2d4b87833ee03be0aeaf514a62e674e078fbdaa7ced960eb87ae7503ffbf6d2b"
    sha256 cellar: :any,                 monterey:       "729a92fc17c18a5cfbedc5f17dc6ad99e9c0dc9761c131c22f773a889907e049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "590724980343abf3cfc997bfd6ca016c46e89da4a5c2532168235f7733bd8fd9"
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