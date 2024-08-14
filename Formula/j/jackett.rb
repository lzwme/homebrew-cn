class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.442.tar.gz"
  sha256 "609e31b55833ba327bb2a60d4dacca19dd8209bef9a393655c0c8464f1325b16"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0dd4b5fa8bcce232a5788548b1f9e259ae01f474cb4aada02d74326c44325117"
    sha256 cellar: :any,                 arm64_ventura:  "f22e3a1c999028320ffe9d29bd400f621648ea0e72339953e673c208ccd59b6f"
    sha256 cellar: :any,                 arm64_monterey: "6cd1bcd5378ce7c50f34c05938295352970aec4087f6af1825925cfb84068ccc"
    sha256 cellar: :any,                 sonoma:         "a9082e282447f2dd133162f01a5b0f8806ca210edac63ed8389f7f3d2cb686c8"
    sha256 cellar: :any,                 ventura:        "6668fb8b89a24ffc9debe4e257d01c8bf9960d0d3cdea07c62487d87cc9b3ad9"
    sha256 cellar: :any,                 monterey:       "c32e9c3b0f691bef0432b0f5a188f5f0f1b1a57aeb5f6e55aa1b7ed1cd583287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87eb938ace1da5d56107e44a273dc437ddd418a265ef91a3cb150de9d6528727"
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