class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.17.tar.gz"
  sha256 "af2a8b5f3114b128b3c1fe32d7c33295214683e5d120b352aca3d71708a4bf16"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "281589325a389fff32edd263eedfe7b155b7a01b794708b4f5148d3d74371bf1"
    sha256 cellar: :any,                 arm64_monterey: "f520962081d92e831e34c97dba744ab2473620272fa07574353c4b067ae10e4a"
    sha256 cellar: :any,                 arm64_big_sur:  "b771f87fc0030ddf43e6057a84a13af91b662bc6c59c6ce069197b15f5fa2f68"
    sha256 cellar: :any,                 ventura:        "e85044c77d45905a6ee4530db01bb64aab1533b8416ee85d595e15836b573cfe"
    sha256 cellar: :any,                 monterey:       "2bc841ca7cb35ca9487a986d6581065966ef176f480eabdb273d245b02cec13e"
    sha256 cellar: :any,                 big_sur:        "2fbfd2e477d37b091b76c5d933d44e580a30255839a12699f6d361ddeb0ecc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19bfe630dce1a5a69a28579eeee3c94744316f80e5fae6a49bd25f0bd59faea8"
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