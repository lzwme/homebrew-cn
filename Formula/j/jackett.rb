class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.43.tar.gz"
  sha256 "9df23859b93fbecd996f728a9f1eceefb1e3d5ed36f62ca0ebae71d5fd21bf16"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "31e13a5e5ec98379539f9b0f1573f8abc661c7df9da92080ae5f11b656f3221a"
    sha256 cellar: :any,                 arm64_ventura:  "7427413bf81fe57e3eb948aebb79c7729fff6b139c63437cd981a9e6c491010e"
    sha256 cellar: :any,                 arm64_monterey: "48a02df5b701c32d578ba2eb14502e44b30e57ab90321acbfeb740324dadca9c"
    sha256 cellar: :any,                 sonoma:         "04e663d71d87f15881142c8752a6e99d0432c5b66da59a14d8b66aab0eadcbc5"
    sha256 cellar: :any,                 ventura:        "bb6275aa78ac195d6cb25b55cda33f6b1892d9aaf8bf832f2fd69ef10f8ef1bf"
    sha256 cellar: :any,                 monterey:       "1e5bfdb29051c4c5e5099f7f14fd0687e580f43123a3596a7403a1f4fe7897a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1243e738189152e8eb888ba03012b41cfb42cdd5465f3c83869b759870f1022e"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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