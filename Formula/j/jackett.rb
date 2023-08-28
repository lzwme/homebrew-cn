class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.705.tar.gz"
  sha256 "1a3058b253edde4c5e5564003cbe7c6ef9c9536ac6661cdfc4b05d19ca410bb4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1eb6805cca309ae3d7a88b5647d13dd76086b28e0e474f968c1e19c91ceed7a1"
    sha256 cellar: :any,                 arm64_monterey: "6cd9a9866a2f63592b6fb2039163f51839c7075b9fa370fa985ab60daf92b03d"
    sha256 cellar: :any,                 arm64_big_sur:  "ffb6a217afed56451c1148c1f4a1b1d15520ab4f13c520be4b335933b5198f00"
    sha256 cellar: :any,                 ventura:        "65ec26793dbb5217fe344aa9e98ddafe69fe041ef938788810416700a849e3f8"
    sha256 cellar: :any,                 monterey:       "409d4e20a22d9b86fca7767a2182de86a6da54ffa03ee5d5a17938c2a1704631"
    sha256 cellar: :any,                 big_sur:        "079ccb4e2faad01903ae615ee99538589067cec53353c39e16b8307c19a9821a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0474d12e0784b4ccf8772d6e7625dcbd22f2b712de390a86b58408b0e8e0adcd"
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