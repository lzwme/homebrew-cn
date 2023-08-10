class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.602.tar.gz"
  sha256 "daf6f7c156abb176ba33c89254e76f3ce48b5cd1a30d8d50a48bc2ec8897258d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b183d57f55f045cd7960637d88dd3eda6ca6d3309ef10ad72084d180a37fa12"
    sha256 cellar: :any,                 arm64_monterey: "2df13c42352d8e9e05e689b376c21ddbf3576065d920f7a485d2839736a25cb7"
    sha256 cellar: :any,                 arm64_big_sur:  "6c638c3f30f94e9f95d79cec7ac900a1b3ba9cec85e55b3059b8934e253642cd"
    sha256 cellar: :any,                 ventura:        "c21f63a002f5e5e5ca503da971dd84f51bb022ddea541288877f58f63ffb61ba"
    sha256 cellar: :any,                 monterey:       "d79e0ad01d0101e254b18729963e1e9676d4976cc88f77d5623cac2fdf27560b"
    sha256 cellar: :any,                 big_sur:        "1c8437069f9cb4390d8bc2b8a9cf7e9f7d3cf3bf6dfb07bb50d10e0706fd05fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca557402129264d494dc8db6b7a0eda4ebba80bc44060fba61c63b1c3fc7343"
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