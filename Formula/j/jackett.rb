class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2335.tar.gz"
  sha256 "3a1d7ef4181a1338d9f9aada8af04eb087d317784739a9a0c8068b9c750f9a8b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e1e89b806d320b48ed3b767ca9601251d6028c484659b8d849d651df86fc34d8"
    sha256 cellar: :any,                 arm64_monterey: "e63c91bcc2c8d7077cdf1f0523920a6512f033dc82dd08d56ef6892fc9047b73"
    sha256 cellar: :any,                 ventura:        "59c89faca7eceecac9b20d4c1585b12b39d2d7b9c4a6f37d6464541889e4f807"
    sha256 cellar: :any,                 monterey:       "872f07d6e7691481384c7fea8e4215d5765f2f517463dd5b7b6653dd935810d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cec67a1c0f767835498b420c398d09f16a8d2e2ae3986683d1f7ee4750095ef"
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
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end