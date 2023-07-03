class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.361.tar.gz"
  sha256 "e40354e2fd54ea4842cbacc4a4ebf2627a62e729959aad8d7b0d7a8ebd344489"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "33f3f83188e881d4790d490ea37a9e16f5a9dec97cde8c6143f2fbe86032c1fb"
    sha256 cellar: :any,                 arm64_monterey: "efa770360f9a2c968da7a45fdf0d93798bc067069f080e035f673204966ed12e"
    sha256 cellar: :any,                 arm64_big_sur:  "eb8bc8960b944068b60a7182b5ca39f1e39fa01cc065c2008d4caf3fd11c654a"
    sha256 cellar: :any,                 ventura:        "8e22886b805eebcdd6bc74a04e50bb6f2082066118669d6fde28f5439e101c70"
    sha256 cellar: :any,                 monterey:       "395668fad561e62284a779f5aa1bc6a71ae59a496e8de3f6a9bcf0eaf491ab0b"
    sha256 cellar: :any,                 big_sur:        "89bc45721e8748c021ea1c5f1dc53353d8f1093493f57610ce834324292401ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e862974e301e8a4324adf7746a31f099ab86ef68d861f450f94b987277e56d"
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