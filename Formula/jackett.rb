class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.329.tar.gz"
  sha256 "d16a490edb2d5988d6e022897041c4c82591a897bfa9432511f8886c853b9f8b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ce10fa99a5787620d8c1b4d21195dfd84cdcccf5d011cbca0c23908fd82de1d6"
    sha256 cellar: :any,                 arm64_monterey: "52283ad1d58f159f7317330b2a5fbd297857a5a738c0b9baf6415255176ce855"
    sha256 cellar: :any,                 arm64_big_sur:  "f47750ca3bffd2c3381451592ac23dd386e07d1e6684df1374707483bc60d4d8"
    sha256 cellar: :any,                 ventura:        "a7ce52767ddd71414e18de01ee8cf40bceb7251fc57d7b1ea82a3b7a699674af"
    sha256 cellar: :any,                 monterey:       "da70e92444fc880e9b509e4bd249aace275fad388729cc8921f64975728763c7"
    sha256 cellar: :any,                 big_sur:        "7a357494d9aab97186b494bf54a99a979e2d83801794264c81a27f29a3da2d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b432600e622034e897cc695e4fd746ee7f803c9270dd97b89d159ab00bdf852"
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