class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3463.tar.gz"
  sha256 "b39303243777b23150b5ceb66cdfc0b20d98840a397d99765c0126d73f342c00"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "64ab2246a37ad53829c085727f1df41027f04654e30644533f6f898ba14ac1f2"
    sha256 cellar: :any,                 arm64_monterey: "153aeebfb1418886ff5c6b845a7a8dfee088cb09f82ad9bbf19d53d7d2322cdb"
    sha256 cellar: :any,                 arm64_big_sur:  "bebf52946cae2e3f89cae4f33e2770c8cf91eb63000789d63f5616db7a3f7dd4"
    sha256 cellar: :any,                 ventura:        "8412506ce02bf04a69148b818043f325b6d2a2de57b618cd967b84b2fc8d8ff0"
    sha256 cellar: :any,                 monterey:       "e07eeab73d52c4d1e30af99adacad8ef9e1871d09b90c44fbbd65d6babd9b91b"
    sha256 cellar: :any,                 big_sur:        "f300ee8cdd228ad77e657518ee839bdbceab420c650524472e650817ea85a2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74ea7f19b0a2263a9dafd3585ecc96dc2f6a5b123b4479dca4d38a0258e72658"
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
    working_dir libexec
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