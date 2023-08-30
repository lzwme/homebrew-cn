class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.709.tar.gz"
  sha256 "b33b71e7808b044acc359d787bfd0ccce689ce861c2c82d7cde342a23c46c150"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4ab94506f1cdbc815762af446c87c199bf18cdbd12aef97b49015bc095afe79d"
    sha256 cellar: :any,                 arm64_monterey: "31eee02247bdca341cd83e09a5397d167b2ac3a26f58204d43afb12eaf5b4a55"
    sha256 cellar: :any,                 arm64_big_sur:  "68fb26d6f2be8d8e9d03e9fc9e8c7e15c4c3b9ce680c5d266af7ca7c8045dc75"
    sha256 cellar: :any,                 ventura:        "d26c474b2da23efeca5dd31a9394c12cc31690079cfb8cc046e5f42c6201b71d"
    sha256 cellar: :any,                 monterey:       "049817d17acafa2da0e61b63f4ec382c6e722a8f3e67887a95d7ce6e91f29c95"
    sha256 cellar: :any,                 big_sur:        "714c8500281b50fd1f6f6ea7ab66cbee0d2d58e2d0f578af939c6faa7d942a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a54727abf06e09fe0f8ea3ef216b1bdd85055f787bcb5e203fca16fac9a29e21"
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