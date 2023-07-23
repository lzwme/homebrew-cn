class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.510.tar.gz"
  sha256 "1abeafbda86547145515580add94521a141064cb0fdc698ae92560cd49d6391c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "04e98835abe70df857995b620a324e0baae41c7a651b9dc28f4af61bf51a8591"
    sha256 cellar: :any,                 arm64_monterey: "ec783b762e76777356f652367ddd5bc46c55f8e0ab0f606131a8c026be6565dc"
    sha256 cellar: :any,                 arm64_big_sur:  "fc67b1821cb23790f975f6a3c21e1ae6614323bc78847c4abfcf9776a7e43201"
    sha256 cellar: :any,                 ventura:        "eebca1d1157292a9b2ac66eaa42055350baee74806442c0760ee38810dd5aa22"
    sha256 cellar: :any,                 monterey:       "fa5c3691a2891a224179191f04d97ed22b427a33bba4fe0411b193152abefbd1"
    sha256 cellar: :any,                 big_sur:        "19907ca63f2750d14cee38a0c70d47d5c3a98d61cf05338f3f2011938f558e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "577760f75f0e2d4f469f7dc17a7eb8c8a8b0c67e92af6a7071376e2f0e3569c4"
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