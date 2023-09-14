class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.772.tar.gz"
  sha256 "42fff26c438e2999de6d85707240138d36a1a807c4bc7421bc1e62b52dc153b7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2172d7302a6ca6d5443ed8dc280d478553009d9994a59a1442de05c4b722259c"
    sha256 cellar: :any,                 arm64_monterey: "9ee359f7f3271e1f2a27c10c7be63fbdd6b74a95613d74fe602d523271eeced9"
    sha256 cellar: :any,                 arm64_big_sur:  "86abbbd773daa58bd2612df9e187350aa390542ca253ba1495feda23e7ca7a98"
    sha256 cellar: :any,                 ventura:        "0562fa2bd3b9109e4280f1531a4109b529b80541cd0a0fe8370460994706c717"
    sha256 cellar: :any,                 monterey:       "c30a91a3f31a2fde7dcecf7c9de986faadd969badd5e47786f1c4a1bab9bebcc"
    sha256 cellar: :any,                 big_sur:        "c2138408e3f36e03534636f3b59215002237a17bf4ea71ec5c9f971a02863077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "547dcdcb503f58b4db3f207581cc5564f7111bf85f4fe77498df9b1a247791c8"
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