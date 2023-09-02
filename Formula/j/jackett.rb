class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.719.tar.gz"
  sha256 "36c3ff191f99ebcbcff7fb0e15cfaefa7ddcea693c684295219ff88b8c68d935"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98ebd20cd65c161f04c7f76cc9f5ac90a3b92f57f4e695f56dcea774f4c5462c"
    sha256 cellar: :any,                 arm64_monterey: "fa1337620e9e064b65b6c6567b437a0d22c36cecc30f3a06d099b7b2926fb4e2"
    sha256 cellar: :any,                 arm64_big_sur:  "b22a41a753ddbfb0a1f1c56a969d134984a62dfb17e264a468b5551a92502f54"
    sha256 cellar: :any,                 ventura:        "d037a8ba92a757894d53e5d724d5eb884c6938a059b32c1ddb52410fd434c1a3"
    sha256 cellar: :any,                 monterey:       "fb313d1d04faf1294814acc3d35ba6ff48ba1aab522b28703fbc301288d28adb"
    sha256 cellar: :any,                 big_sur:        "e4532545f66a6e0f1ce2dcc2b93c062bc5351eafded1f874d77294580b398f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6136592550ef032a026169cf4cef535c3ea6199ade568080c10348e7e3a94795"
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