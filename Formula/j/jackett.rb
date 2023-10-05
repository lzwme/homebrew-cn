class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.958.tar.gz"
  sha256 "51cc507d70abbde94d6ea104d150cc5c1c376a9971f4faa9c43f091d7e01b7ca"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "46870b67344be7ff12e689b5a7f284a3c54b36de0a073217b1b65dc4b9a6e9e4"
    sha256 cellar: :any,                 arm64_monterey: "0108134654165d4b3a005d2195372fb9dd27103531885405414e5fd0328bec0b"
    sha256 cellar: :any,                 ventura:        "8ee7465103e22a8b3ed2c7e55a7c9df9b8bf68383dd53f69a8554b62e34bc0e9"
    sha256 cellar: :any,                 monterey:       "950cf0d07e314d0fc38d5f8f24a4ba3392991c3b729e2cda78885a3fbf98ebe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "663e5d8a905246c63b56a26ce21a7c18505133c5aeb0ab2115c63a38258c3adc"
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