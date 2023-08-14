class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.637.tar.gz"
  sha256 "f82febcfb71ae0c1c36c629df1cf43497c240f90e4a3135530d37e53d208e37a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "685b535c274e01b17c54ef57631842e8bba85bdac50b5c45f3a764f36c1a8d53"
    sha256 cellar: :any,                 arm64_monterey: "b2d5a40886893c036e922ab61f52c3be02e700f89f895613cbf1527dcbb88cf7"
    sha256 cellar: :any,                 arm64_big_sur:  "b1bac0095974ff2b2f0b17cd44cd03bf62a446522dfe87cdd6f8558ccea95eb2"
    sha256 cellar: :any,                 ventura:        "fc220a16fcba74a78c4a53deff3a19f55c4601881e78351680770fad74ea9d1b"
    sha256 cellar: :any,                 monterey:       "d907b0e44499ff0f0620dec175b6a4fbb7fc42c04d66a0184ab360d5136971fc"
    sha256 cellar: :any,                 big_sur:        "8a5a2f81aa39a8815a218eefda6f703604bbfed89fad232723f76bd95181198a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "431158e679a68005207cb671083dd40521ec341d69942f35a7dc4e7394e24afa"
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