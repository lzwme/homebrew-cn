class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.34.tar.gz"
  sha256 "e7b0f73000c975a52708b0b3e069a6b6d15846fce30c6e2e72ba8c9132d7cc3c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c67b1b7e34a4804d5a64ee9445d0922f3edc9f5f34ad49864d104bf6d67fd0e1"
    sha256 cellar: :any,                 arm64_monterey: "3fd0eb746eac6652e0526e445e79e796d1b4634d6363a0e79978e9aa1e924b73"
    sha256 cellar: :any,                 arm64_big_sur:  "00835dcd78b2ecddb72a63479a51f82d40b9cb05ee29d55beb43384a1f6edee2"
    sha256 cellar: :any,                 ventura:        "f6cd21a1329f9521699a1710d8b604e6600e917da38c866c4b42e3a657b35adf"
    sha256 cellar: :any,                 monterey:       "5c7d35159f8d97f093702cb01170a2366b53e7b188445cc15c44c3afad71d457"
    sha256 cellar: :any,                 big_sur:        "41a6cb4b6d058081711ee78a5ea865a851b1cd33dfd124fe15622502b571a884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c599397741d07bbd9f61544d83005cb0da476d851a09a210218bcf4553491209"
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