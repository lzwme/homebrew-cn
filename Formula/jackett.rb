class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.114.tar.gz"
  sha256 "e60a23fce8e385fdb2d0c9b883661943f141e8c00cbea5bfadb0d1a643377a91"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5025c07a9dbae58d9562016b7a7be44ba787e0df3fe0ccded1511b2b98a0e15e"
    sha256 cellar: :any,                 arm64_monterey: "61619b2a151bb7e28c7ef9287148a39f47b49f47df0b924d1e0defc0a9ea6a1a"
    sha256 cellar: :any,                 arm64_big_sur:  "0467d75a525dae84d2ba1c5c44a7a488bb9ad196218030964e65efef8b9c3659"
    sha256 cellar: :any,                 ventura:        "0718487b49d7b027d5dc6088c5886ec49fe8f25e9a344198e7862f4be364556b"
    sha256 cellar: :any,                 monterey:       "c2909cd3bf7bf255744e83b3d0b2c5bf424d558bbad66d76aad302727141c863"
    sha256 cellar: :any,                 big_sur:        "03104dd549fbdc45002c6e6f4e841b54cc46ecfa92caaa8932dc07e3f2fe6153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71951e7e3479b362e173f2a67dd608816010187e89b00741f40090b609a9a55"
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