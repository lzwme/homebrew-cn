class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.42.tar.gz"
  sha256 "6dd772a191406ddd908a055989181b4a82a29892f614b83dcd6de44145aaf18e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f6a2602ae4641cfd6815513422581b9d5eae2a4a93078238da4e02acc43d5ee"
    sha256 cellar: :any,                 arm64_monterey: "dd7a01eeb683d646e61459d4e4caafaf73df4dff527e0ebb47a7c40a1e2cc0c6"
    sha256 cellar: :any,                 arm64_big_sur:  "eb7769978130c3b894d2fb446f21bc158e2ce87f826d1f8f564c7fef3abd067f"
    sha256 cellar: :any,                 ventura:        "5f039972c066dc4277192527365ca256982ade7a50076eef6fc6de0b6fb7eb56"
    sha256 cellar: :any,                 monterey:       "3c9c4f58ad8d4265e948234ae70774953982b02c434a426942fe46ade92e6b9e"
    sha256 cellar: :any,                 big_sur:        "6e80e103af445ee9e60f6b71fa74cab0d4cf838e1b33fe6f1106fdc00951345c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab0c81324614c25020dddc6a6756b97521b66ffd5b3d43048cd1387c789e0c1"
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