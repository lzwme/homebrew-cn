class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4145.tar.gz"
  sha256 "d5a4574a79ff368ecc6c3f4400452609411713c9431b407a8b4764f3e8dcac47"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd4962d419d031d3846bac215b013260b2a9c7394a723eb4f9d54e55608a309a"
    sha256 cellar: :any,                 arm64_monterey: "e50f8f71e2ec6e93032737800dddec79956cf562702decb191aa6848fe34d8e5"
    sha256 cellar: :any,                 arm64_big_sur:  "93f4df7203a265184f3d427296561a9331d8a48be68f489654e779c238bac64b"
    sha256 cellar: :any,                 ventura:        "08463423ab1cd1ebb58dbc3e45bf1a28e194dc70367a3738222464eee7ecbcbb"
    sha256 cellar: :any,                 monterey:       "6881301a9f81a62f17ccf7524de6c58ac4bfb731a9b8fa239af688a8e695be93"
    sha256 cellar: :any,                 big_sur:        "385c48f0b2600ee22efa60d9c350db0d2d04f9fe4256a4ec9d08f1327d5da73e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e077c554273756f654019ee4df4886f09fab5d41ce6c3b9b0d2f40da0cc5f58d"
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