class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.547.tar.gz"
  sha256 "bb7418dc992a22b1d4b3cf0c7790bcd2538cf527c3edb45caaa5c377d10174f1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bbb1edb316e17e2feebc8ffa4a49276e60f8acdd2a1d93629c43206408b5b7b1"
    sha256 cellar: :any,                 arm64_monterey: "afc7c1be89329a6e4ef39a959a6f604be1d2d845343de445db1095f216004346"
    sha256 cellar: :any,                 arm64_big_sur:  "b3617ecb147939b275163dabf619967b4eb3e9dcfd617aecb89bad8f67f35159"
    sha256 cellar: :any,                 ventura:        "553c71811e9e9d5974999d745fc246c165e31fb27d13844b4ef11b0bbf9d0649"
    sha256 cellar: :any,                 monterey:       "d585a04148466d91b7aea242e9e11b1a0a0b5f6e4bfc9dfd6a1a42df8d89c68b"
    sha256 cellar: :any,                 big_sur:        "a47c6bf39a5b781d3a901d66d7702b7e2117fe4bdd53af4905a0b731825e4f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f73aeb9a0206f5d7f1477c8d7a66a0168ef75a262cb9d49cacd03d51b9f5408"
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