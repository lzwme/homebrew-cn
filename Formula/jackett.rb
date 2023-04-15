class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3903.tar.gz"
  sha256 "22b468d78691e337b58421236043bf5a7aa545a175c514ed6ebbfd66ae411c06"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "50fc1451bf6c81de18f34600063f01f62e7bd6f04812595c86afee5530c61dc4"
    sha256 cellar: :any,                 arm64_monterey: "bf8d8d9d82b06cbce8b6dd01d31b78d32d546d41b4b15805c8889b89100b95be"
    sha256 cellar: :any,                 arm64_big_sur:  "636ebbd329293258cb937822ecf8f2f4bac12055c8e7967c9589fda260ffb4af"
    sha256 cellar: :any,                 ventura:        "3b98f38ce3bb64328154b7042ce19e5b37f6a94bfdfba9fe28808d4e74f16cf4"
    sha256 cellar: :any,                 monterey:       "616168fa0da2f6ffc753753e5a7c43c2adf93375eba40f66fd6c85a37096e277"
    sha256 cellar: :any,                 big_sur:        "9cdfb01eda85339ab605751b81116fb7bd026439dadab8ca97a5fb529b68e799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d1588c598e42e18b975a7dc434fd9325bc77dd7b9a93086ebbf59fbb65307f9"
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