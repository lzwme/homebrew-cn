class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3817.tar.gz"
  sha256 "fcf7ee7af030cf50ec3324917e2e624135b53c21009ed0087225bed5cb328430"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ba31b792547f2b0ee49b8c4c9a198a5e159bec7ec62383f1a1997a48e0352457"
    sha256 cellar: :any,                 arm64_monterey: "2cc543c809e9a4e336f6663e1d3ec18518f26f56f877a5b521abaa3a37615288"
    sha256 cellar: :any,                 arm64_big_sur:  "9a26e8cb1b31e182ab0aceb72230fedb9052e023de63c216a65604b17b3d9430"
    sha256 cellar: :any,                 ventura:        "4d29f6fb339e19c7c27859ed806f3a2fb7341c5e5e63593a720056f927b22e27"
    sha256 cellar: :any,                 monterey:       "49b7b34435efcb7b03752aef6080ae15638878632e53bd5fffa9a5fcbfb84a06"
    sha256 cellar: :any,                 big_sur:        "e0dbf2e15b6a1d582bd11546162ea505299d6bba8585973ede7674caebb937a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d46b1fc564c4386800618195130bf8d5da70d1ce52b07ebfabfe91b0e56de1c1"
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
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end