class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2278.tar.gz"
  sha256 "be14126bd9732803761e7c9d5c474c611914e540668e3dc0cc630bfdfd08045c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c2959543db44ff04db00248b178fafa9a4284bed8777e37bbeabb49ac895f5b"
    sha256 cellar: :any,                 arm64_monterey: "117ab75df20ab3239fab112a46c605f836b0b1d03fcaf7ee16b1072a46aaed66"
    sha256 cellar: :any,                 ventura:        "728f3ba14de93e45d1f5f90a15ab8a8305087809efa166a88cc743ad7eb2f6b3"
    sha256 cellar: :any,                 monterey:       "d868e6c200fe58094e94bf5ee12edd698f516584d90eff7531cd0d65d958b138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb7a4e658a89c002dc9e54c9988cd726d0b33a58aa8cb5f45943fc12408fffb"
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end