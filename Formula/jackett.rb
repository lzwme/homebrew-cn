class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.611.tar.gz"
  sha256 "07f14c27375cb01751defddd646d9741251adf68dc972409a973d1d9c40198a9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1928149d8ae42779fe8d9b46eef728360e14055090ce2867d44689d4a3338b58"
    sha256 cellar: :any,                 arm64_monterey: "632aa329930e958aab2f76fc3aad21d3ba8edc1df1e91d29b18f0a8ce6382491"
    sha256 cellar: :any,                 arm64_big_sur:  "2b811a13c7bc0e2bb6ceac56f93b033e6e886a8c67d02997fcbdd6856214feee"
    sha256 cellar: :any,                 ventura:        "df90ef740f1bde8780a03018ef44ae56730872f533f684d41c664dded8c40c9f"
    sha256 cellar: :any,                 monterey:       "1228f51267069b29839b5bd8c58b5b29111e5660913775afc048bb7e156feeed"
    sha256 cellar: :any,                 big_sur:        "c12d64b8475ae774807f353c0946da38470725e15e6ddb525c0c97ad3b751c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb3f6dbc73ac014863dae013b54fdfd29031804ec3303ed37c4ab3e24f213e5"
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