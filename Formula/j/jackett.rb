class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.983.tar.gz"
  sha256 "fed84834aa03630fb4e6581d69e87824b2823fbc94d08d6627bc12f8d0b6ee06"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ac4ecfeaefef5d2d321103c3c28533a35f8c6885d087edf8b6c618235db33fa2"
    sha256 cellar: :any,                 arm64_monterey: "17230b424a07e50f752fa53affddae32c66e676e06aa553ca19e64800315ac6e"
    sha256 cellar: :any,                 ventura:        "215587537766cd28e92095ed4c8b84cf0e32e49b21884b6e2419deb189fb7f93"
    sha256 cellar: :any,                 monterey:       "fcde8c7903b0801b49f504a4ba88a976eee775aa2ba923a5fb256642f8f71a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "361ebf2f0c7b0e265cd9316619cb01742d7481c7acfd287d42a22ef90d3a0c2a"
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