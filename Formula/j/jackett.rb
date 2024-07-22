class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.355.tar.gz"
  sha256 "645c03949769d1023840983de6e79cdbf356d6f1cfbb35a0d6348367ac306e61"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ecb9aec28a84fe2b37eda46f0a89697c197a0aef55931f18fbb6bf79f1e4ff1"
    sha256 cellar: :any,                 arm64_ventura:  "1da70eeb2c811299bbe506221a50f812cf123c3dd932b1826c129d0c5fd1204b"
    sha256 cellar: :any,                 arm64_monterey: "c59335e84b0041c9a82ee1719a9610ebbd21615fb4a6644436d3c1ae6b089bfe"
    sha256 cellar: :any,                 sonoma:         "a8550f74c6f106552ae78adca7495c24b198148728a143906ca526d31e9442ce"
    sha256 cellar: :any,                 ventura:        "88a82cedd34cff1f5582b7be13492045c8d5994b0ae12996bf4df3e1189b1f52"
    sha256 cellar: :any,                 monterey:       "fa7b087e750706e7cf9f00eadaf577a7e0161173a3993f7395490f827b80bba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c20c692ee1ab1dc27fddb6ccc16da50e05b9c8c158e537378d7a01adb7f5f52c"
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