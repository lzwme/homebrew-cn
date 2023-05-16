class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4148.tar.gz"
  sha256 "45af7d043b4351a62539d0dcf9c5aae7af02e532623cb233cc168fe03d922256"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "608ee52617a04f9b90b326723ebea994e2ce349850d14a534d9d0b94e424507e"
    sha256 cellar: :any,                 arm64_monterey: "45aa733aa7ee6b3a252c029ce1010cf36a5935eb55e93d4a2e1b460b22075359"
    sha256 cellar: :any,                 arm64_big_sur:  "b1e31be726b6f50cc8fca22ea1af9434a7de10a9912a294b301aa98238e8dc6d"
    sha256 cellar: :any,                 ventura:        "62a82f452038df0fa00d9e26cfb8c2f366a7c0b0059edc1c33ede10740a44eb1"
    sha256 cellar: :any,                 monterey:       "622a91a60116c01bb94b8f4cc279c4f91f5a2b5ab9064da782d1e0bb15f586ea"
    sha256 cellar: :any,                 big_sur:        "b986322df9958dbcfc7b3278474485ecf34e0db229446d01cd662fbf32307a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3ebf35a1fda01bc7d1790690bf6be819b606a4c33c94ac427fa47fc8e33f0bf"
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