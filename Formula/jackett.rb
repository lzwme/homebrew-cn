class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.534.tar.gz"
  sha256 "56830bbc2feb466d4a8ae9ed7b5206f1112e01411649910858a7626bdb061308"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56f5ce6958a789c398dd8a01fdeab94470205541db317c1c7cb9ac15296376d4"
    sha256 cellar: :any,                 arm64_monterey: "3a0a9b75160aa2d1ac5837e9263e4fb3756054fdb7a5c04b5b348c799b0cd77e"
    sha256 cellar: :any,                 arm64_big_sur:  "ada4b17b49658ba45223efec3c0fd647798598aad2f6a491e93f2ddd92bde16c"
    sha256 cellar: :any,                 ventura:        "c95e0c48a688e78c5dc53805ca0750ef84dfa9dcd810103a2d03ab12d3151b43"
    sha256 cellar: :any,                 monterey:       "698f063e5974b8576a92806de0aaa5ecbedaa5f4ae2b2cafed4299785cc8de13"
    sha256 cellar: :any,                 big_sur:        "b16f47d52243686288bd59d34d5bc2f9fd275e788e8cc7503b04dbc9ac2e77d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef9933a595c65e74b6fe83dd6b636ef2fdf4f91f299f55e4de00edf01403a325"
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