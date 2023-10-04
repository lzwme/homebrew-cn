class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.950.tar.gz"
  sha256 "70c75775dacd4f565ddafdbf8030a5631ca3f71a1ce887fa3b22b754ecc1118f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4009dc8b5d4551bcefe3374560226ce42c51f71efaf11c18e1a4aa2270792f47"
    sha256 cellar: :any,                 arm64_monterey: "510d5219fe1ed0d2d09d996dcf16facd233654079b2891e3a50305ed0417b5a6"
    sha256 cellar: :any,                 ventura:        "623e378f9d9be4337cfcc0caf3c1494d7db60c30a7e16116aec749ffd117f2b2"
    sha256 cellar: :any,                 monterey:       "a2cfca4d32b32c620f0c512c70d59de71e12a4d570d7cb4b24d350ace02814f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "750c7dec591bab2e53414dc244a1d4ccb51e951c2c6ac4d5ad34d535dc4c6319"
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