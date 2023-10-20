class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1051.tar.gz"
  sha256 "bb2739a93f9d898195e0fa11e0c8797a9de63edf4f1364dabd335b189f0c9523"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a864017b7dfb58d515a174876fd9921d2bde6d91663bd99055fa8990b44e985"
    sha256 cellar: :any,                 arm64_monterey: "1fcfae07aa97ee991099168aaff0a37b8b689e912bcc64e06506be86a86e640d"
    sha256 cellar: :any,                 ventura:        "9a8800b7aa2061b40eae74cf4468d38c653d08ea277f6c292703a5dcd76584b3"
    sha256 cellar: :any,                 monterey:       "24ea60398fba191820ff60886274343cfecbf76d587bb308a975f17baae40de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0360b5db00ca1f9c1dde2d398f26f6e33e9ba112e21796c780a20e09623e3628"
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
    working_dir opt_libexec
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