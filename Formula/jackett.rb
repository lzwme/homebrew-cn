class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4078.tar.gz"
  sha256 "f5a238249cf330800b890def67f59c02ae5b13042095476f7dfc54bdb9d3c35b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f47cf4bf35e0e7b6e462d90e7e46b680b328f2147e1eb926e9de491c0d12c7fa"
    sha256 cellar: :any,                 arm64_monterey: "442c8887e74fadd8e605a77e9a3da3a47477a4beddd1289dd091abc0aa9fbee4"
    sha256 cellar: :any,                 arm64_big_sur:  "bc7709f7c1492ba02caacfa2fee6baf6c0b7804eb0d364e00a66bc1fd9fe6539"
    sha256 cellar: :any,                 ventura:        "8aeb432830282d7556aa8dd473e0e6fb03aa81b7760080a71b2541669d15215e"
    sha256 cellar: :any,                 monterey:       "741de4a53e5c71a871b4425feffa53775150773adb56f2a92c8a170db0cc4f7e"
    sha256 cellar: :any,                 big_sur:        "d7cca7f74a809eb593b3ff11a3a79e25e0278d01830a21abf72941d8ec207ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc41b7c81626cb6ce29e9598044ab5375c9567ebd6d86c734b1ce77dc58d8569"
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