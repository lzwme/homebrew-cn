class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.771.tar.gz"
  sha256 "fdad8fc670e7da124fd6bbbaf49a6d781d347732c4e9f34aea8e766d361f1cf4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "27b4f3e0dfe9d425336abda3964b3b7277c2068d7dc2d2f3ac084e94318c1a52"
    sha256 cellar: :any,                 arm64_monterey: "7a83bb85bedc8692f4bc4e2277c0d7de2c3983dbdf6388e4efb84f448e2c1244"
    sha256 cellar: :any,                 arm64_big_sur:  "73977bc48fc8755b401cd6f41d4e186fa561f74db3e1db111fe797f0594efcbd"
    sha256 cellar: :any,                 ventura:        "c508b7fa562510ab3839e5b6e88c11f6fed795250d066819a72e5f4649bf0448"
    sha256 cellar: :any,                 monterey:       "5b56d1600686c03e14540e486016675ff22c3ca7b9a7ac36e5c7ec67d1f30c5c"
    sha256 cellar: :any,                 big_sur:        "0626763d8674d5f5b34389236ff06e6f2ce6292d74d6be67865efb386f58e914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f46e26c44e4ea21b5d094beb76048a32b0ecbedb14fe36b28fc65747d716501"
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