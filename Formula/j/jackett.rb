class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1396.tar.gz"
  sha256 "754f7f5c5235dd234bad69a929c28c289113ae544e26d6be25052710f16dd3d5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "adb7eb3c29d10482a5ea7c94bbc1fd1f0b9a71c17f9d8edcb6d0df4c7fa0692c"
    sha256 cellar: :any,                 arm64_monterey: "404267d614fc9e8da51b10180c87bb7a7182f1e6aa9bdb987abeacb0dbfb7072"
    sha256 cellar: :any,                 ventura:        "3bacc8f81779789d55ac317e613bebf03bb2fc7b374fce36ab748265f1519737"
    sha256 cellar: :any,                 monterey:       "70ea6aab9a0d0915cd8f277df0a66d592cda860ea5ee1fac9c03c231019ae516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5067425243c16b995165fd34aaed32c48f1ef535afcf709682ee303320150901"
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