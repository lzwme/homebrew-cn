class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1073.tar.gz"
  sha256 "c4385b00add96950c98b06c4e27466e1d6f1e5cb9aa0b17464bf94774043567c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "68aeb9b36897459c19b2a19b9da57da45fc7816a12a9ab5c35a32c5e7670e137"
    sha256 cellar: :any,                 arm64_monterey: "f61ff1f1f91484926626cedb89ea81819925f237daa6c307f925eac4f2759502"
    sha256 cellar: :any,                 ventura:        "84aea5114c6350227d3ee3a262b5fbbd0ba5a9f9bda254de155e4df9921bcf4c"
    sha256 cellar: :any,                 monterey:       "a3d8432d865eaf62ae9aea549ed11a2628a79a52980cf1017a7cf4b4babe370d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b2c3467e827d1115211ac4a63261123721945131939195bbe0b26c6bc7ab19"
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