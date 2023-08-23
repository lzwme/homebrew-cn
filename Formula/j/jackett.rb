class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.681.tar.gz"
  sha256 "947e3959f6d558649a36fe5b975598c7f526b1ba83c8cfa6beeeb3459ced3de8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d6d6746ea01dd94a7cfc2c1f971578897a105ab0429801382fffe8ed81a56e4"
    sha256 cellar: :any,                 arm64_monterey: "31983aa83695db3479705c645c08af6cecc6adac7be1a597912fc45b19177b08"
    sha256 cellar: :any,                 arm64_big_sur:  "374e087d68be672b80e6ad649b913776938690db18e1fc90c31a2449b7d595c5"
    sha256 cellar: :any,                 ventura:        "29ae20662516ecbe53c3c40af0d0b99698cf8959adeb16398e99b7a28ab75ecb"
    sha256 cellar: :any,                 monterey:       "46a975b5e43f7735f1e072c59de53685c5e3135212834cff30cc4db1aa95ae24"
    sha256 cellar: :any,                 big_sur:        "9869ac67a12833f8ce437d519a02c6f24357efb8d6e95ec3cb02b095db796b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e72ebd1820ae1b9767de1c6aed58cc35830e66e672626074219b40ec60410ce"
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