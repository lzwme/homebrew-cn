class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4166.tar.gz"
  sha256 "81c4600a25e4bde813529c1cdabf3a2c2860b3a5829d553adc0bbcfc4db6b6fe"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5cdefcec2a032b9a90e4f541bd1a2fdb7f8d55b29ec43a3438c35fc2367695f2"
    sha256 cellar: :any,                 arm64_monterey: "77d519a17266f3e61e39aa5150ac5e645fc020e308715a8b8bf252145fd28e7a"
    sha256 cellar: :any,                 arm64_big_sur:  "095247c9f6e451105d6fdb4ee36d23a70da72501778547dd76a4c1aab6a627b8"
    sha256 cellar: :any,                 ventura:        "a13182ffa0e9d0a906e85808383f35b4e2b0e0a67a971ffdfcd9b5ede3977cef"
    sha256 cellar: :any,                 monterey:       "ca85030debe6a99aeab8d4829560f88ab86e86f326e3244569b9561bc274faa6"
    sha256 cellar: :any,                 big_sur:        "5fdaf994aba492a4ab8e50638f8239b9015c7932b2cb6eb8e5f2a4fddf17dd2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a78425982191b88ec17ead875538230d432fbdf6837c4dfe26466c8bb680349"
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