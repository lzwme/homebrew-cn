class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3906.tar.gz"
  sha256 "90d01c77a4a63658c834a9d929b8b020e86b57d741cc95a5a4b23368d703057b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c655573a5aa9749d3868a2bf60890528e9d2290a47b8b085f2da717a7e1e4747"
    sha256 cellar: :any,                 arm64_monterey: "4eba7faa0a8db0401c56ebd202d6b161e6cf8d9a5c263149e0de489e5cd7df7b"
    sha256 cellar: :any,                 arm64_big_sur:  "a5ac0193b7955668d8952cef68380e1691a0e7f3da0216e8b34b839483bc114f"
    sha256 cellar: :any,                 ventura:        "fbefccbaea7e029311ab98e6f3d839f40c4ee5a21792161b68234c557d9456a7"
    sha256 cellar: :any,                 monterey:       "e689b1687fe18d9b0489dddecf81a56a86a5b627f35dbfd9b35a036f61c70f31"
    sha256 cellar: :any,                 big_sur:        "afe0f065989d2c06b8ca9f2cdaf50a1a34a730db9b5453e22eff59a264d124fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee9014d913865dfb206cb58dd40fea0cd22d8766471f176d35e1a077c0d3b615"
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
    working_dir libexec
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