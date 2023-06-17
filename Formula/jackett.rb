class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.235.tar.gz"
  sha256 "0612718770d20e631c1690725c812d669b37cc80d0ef71d1f2b9f24bea7ec676"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2639a0cfabadadc05b0002d36fe8139d12fcaa828547666171f07405b9d27b80"
    sha256 cellar: :any,                 arm64_monterey: "4417e11317c693960fb0cdc3c766dff4a74cb4b17a7e38de976db433ccb3f5bf"
    sha256 cellar: :any,                 arm64_big_sur:  "0be7524a3e68b64aed3397e0301849d4db86c7c87618d008389e119dc8e6f0c5"
    sha256 cellar: :any,                 ventura:        "3b9a1cdae48b4a9ff073045d38e56d7fc89f918e553d1784eeaae12b712e1379"
    sha256 cellar: :any,                 monterey:       "0fecfc4b634cd32aad4023006eaf50e697e35875604272938004e4259c39022d"
    sha256 cellar: :any,                 big_sur:        "5ce8fe9576c765b83fd6958058a04cdef0135a466cfa235c2a8560ca7b4d7607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b55dddd6179effe71fd7540839599d095d658638edfc58b615bc64400f4a8516"
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