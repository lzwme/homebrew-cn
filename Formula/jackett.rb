class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4071.tar.gz"
  sha256 "9d51eaa2cc9cf7a9d7e19bd9ea178beeb12a681aee7878f3690f7f8ee871da85"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1314a3c2571e55e3ee0783226ce4ecf0f906965320031348054bf3cd494a2f6c"
    sha256 cellar: :any,                 arm64_monterey: "2be16798661a9db5319ea0760ef0d8913fda1ae8ef33b8c97d37629710ecc785"
    sha256 cellar: :any,                 arm64_big_sur:  "bd0d78867bb70b2388e9c2ae4911628cb8a1aa0211ea177a93f339ad8bc9ba7b"
    sha256 cellar: :any,                 ventura:        "28fc6a19e15c7a975cb95acf6eefab8fac2b6cf70216febd58846182e1fe3fe5"
    sha256 cellar: :any,                 monterey:       "794ba39ff43d45958836607048eb4a76b1fb6e42c0eef22f5b5f7fad1f676d3b"
    sha256 cellar: :any,                 big_sur:        "cc5f11059cbe92a934bab692d654782d8f6f8973994839ddef2eeee74e9f22fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fce68864e03af2bcdabd90ba2f637e7a73ac1e18b168e14deb0042eb560bc5fd"
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