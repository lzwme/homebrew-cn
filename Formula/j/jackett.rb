class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.716.tar.gz"
  sha256 "3c8365d79028601dc884b3bc82846eb8a04b6b3675fe1216e4373b5ef5da89f3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7a14174d50bfc04fa87ab4755be082dfd0b3ccb0726b83750240ea100af10d23"
    sha256 cellar: :any,                 arm64_monterey: "12a37eb640dae86a388d048f34309839f5130417fec64b42281375a6d20e6a8d"
    sha256 cellar: :any,                 arm64_big_sur:  "6507d459983aab5863f0299b9c86d9b2c5410f44359b84f4e330eb0e734169c4"
    sha256 cellar: :any,                 ventura:        "9a09edc95115e80351a524e63e61c0878e92a6a239c81bc111ac86db7b8eddce"
    sha256 cellar: :any,                 monterey:       "58d70498aa0d1dedf348de09ef7d6ce8e9d5fec276d0163261ac13e1bddfe3ce"
    sha256 cellar: :any,                 big_sur:        "c340094e2684afbc75369beeb0f59554f153702cf6cb55155ba7adcc31793804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "571eaf6cf51da1fbb1a0343b8ca5e56b0170ded4f11fb97dfe74b199bac0e977"
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