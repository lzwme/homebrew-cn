class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1310.tar.gz"
  sha256 "d5360d2b652c79209507bfe011da65302e30c7c59364f264587ee22f2f2ae3f8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7557d3826308c9b813f07aa5ea8814be482e615c991f243f239ef3c3404e33d7"
    sha256 cellar: :any,                 arm64_monterey: "dbb2fefcc26baf01c19b5cf26378bfd3bbe0819c513201b99e7bef627da29d3f"
    sha256 cellar: :any,                 ventura:        "86bc3c55645971e289b789b8f3913b1d3208490825c429786e34fa01303f9905"
    sha256 cellar: :any,                 monterey:       "8af7791605a7b9f6374d028d32d8c0e991170b061b9bca84f6911350a1a3ed5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "009f2e24c8fa2c7a03ac0706cc21c72ecfe2a29bfc09f9023e13b5bf839d6f74"
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