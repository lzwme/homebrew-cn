class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.327.tar.gz"
  sha256 "c1ed80c9800945e66d94d78afc9833e46335fb91c3608054c8db3ba4aa0f446c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fb883883ab4296e30d89bb9b94d169a668250917a08afef57eca93def5e4ab97"
    sha256 cellar: :any,                 arm64_monterey: "a6f6d1ce51c3d7c52cbab3e9f8e306774e53d4c8114467ae882cb9f78d7c1505"
    sha256 cellar: :any,                 arm64_big_sur:  "9a06a1e60a80e5df2f2772120357a61fd5650c286cc5f8d2db5972664f018d9b"
    sha256 cellar: :any,                 ventura:        "c09d54814e472ed7ab730efb6e2f732e0d1f9ad36609a8d2a7014c09c37b4325"
    sha256 cellar: :any,                 monterey:       "967ba50dbf8b4dde2d1c28390cb2a0d3cbc34a88392526136c4f45bc320945a4"
    sha256 cellar: :any,                 big_sur:        "3c2cf16d7a95a692b902d9d86397d37e0f6b2cbde037e22170256b407693ad36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63bbcbadf85921e95427af55a58bbd5c262429cd58677ec642e7b64430f748cd"
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