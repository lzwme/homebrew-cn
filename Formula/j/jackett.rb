class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.756.tar.gz"
  sha256 "8907271155506b06d9aa2413c4100126274d58cf0a9dceb0610fc4ef76f3486f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b6a51aa8c07038d300ec3632996a0ff0b99df2f9cc26858b75348f951728f875"
    sha256 cellar: :any,                 arm64_monterey: "0b7f66b5694383d2f74883faa37d0df3c00465979afc6a5e2c7c97da5caa1bf9"
    sha256 cellar: :any,                 arm64_big_sur:  "57016999b887d2d5ca0a72d63148ebd4f8a58d37261035f4a1b1ad795bc8d24e"
    sha256 cellar: :any,                 ventura:        "38c05e90b55ee4489fb0eb83fcca3df40a4f6401ff02d8270e768c2f4e5548dd"
    sha256 cellar: :any,                 monterey:       "e453769dc8c53ece323bf474320be79fef062677597efc6fd8a4ff69c7e744a8"
    sha256 cellar: :any,                 big_sur:        "b6cc38d8366427c425675f1d0246dbb49a11b17eebd5608f64fd06b5d3de9167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59c01867fb5699f34c2f1cd1f72db81ac2755f3aae51f55a00062c2d0411761"
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