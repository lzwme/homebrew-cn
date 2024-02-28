class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1861.tar.gz"
  sha256 "cbd97286df696f70ed65831b7bc5e90aceb45295aefe0ee3fa3315c625922e2d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f8534fd788ea7b04ac887c73a5bd2fbb91b9b0352ae164645aa6a0085222846c"
    sha256 cellar: :any,                 arm64_monterey: "55fc6f49f325fc845e251fb3a41594772f1847549985ee886c37fbd29b659a72"
    sha256 cellar: :any,                 ventura:        "739811b85cb8f25270e35248968c17973934874db3fd984ab0b22d6e989fdc35"
    sha256 cellar: :any,                 monterey:       "fab5d981ac85b7096d62c1d984e8af91ab43fefd8750745dc8c0028cc01ec50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd49f782817148099b15d4cc0c5bc894ca4d75dcf8ce1809a125bfe0100184a2"
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