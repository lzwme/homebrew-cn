class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.477.tar.gz"
  sha256 "bb58fae05974611706040c9098e1deff6e0727c309687176c86357fc7ecda9de"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7176e4528041b074f8c27fbd73a810fb59313b8beb31a20190c42f80bb1718ea"
    sha256 cellar: :any,                 arm64_monterey: "58047e99dececd19d363c160e5ea60f699ee819f0cfe6f7871acfec4411f6107"
    sha256 cellar: :any,                 arm64_big_sur:  "67c08681e8ebce3c948a018216ba4ecdaf8734f2a7412a025dbcbd5c8710ef1c"
    sha256 cellar: :any,                 ventura:        "5b7e814b5c612dc65e92516aa4f0a78d27b40bdc377e50c06f0c2bd2fffbed66"
    sha256 cellar: :any,                 monterey:       "009d28623fb23e61a7f6ede8852ffc25e3768730fa7b6dc6ca8930f2b3ecaf4b"
    sha256 cellar: :any,                 big_sur:        "f33abec39bccbb3c9fbf47f6e4271a659ede3935d219f80a05e102e5a3fbc538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f1be5adba2ffdae29eb7572543549f9a57dc1e6592d49a1dfb0341167c21d23"
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