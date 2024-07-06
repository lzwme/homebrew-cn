class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.277.tar.gz"
  sha256 "6831fe23294f294189c0a62d1aa1094047ec719f1f9847f9684a3f249c7130e8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "446db481748566c5c7a1c8ebbc401e4b2706d32857faf73135e6a476a9318143"
    sha256 cellar: :any,                 arm64_ventura:  "332a410ef0068f954d3a0d56dd7994e15e9bddde8a4663e477abfba89f14bd76"
    sha256 cellar: :any,                 arm64_monterey: "c8de8c522f0d2533b291770f760a61533fc351b5820b5110ce19567948839578"
    sha256 cellar: :any,                 sonoma:         "1140998f17ca8cf8a158c25174df82581d16c40f28423772b1da5dee04793b0b"
    sha256 cellar: :any,                 ventura:        "8a27eef7be276b48ef26a7c974d93e9b04a593a6ca08547fb8983f0dabf8b155"
    sha256 cellar: :any,                 monterey:       "2788754e5deb161362fef8cb3ca1c6e492d5b077de843b3cb2d87c8230b181ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "664227889c62c5a027a916431256bf903abbdacfeb86af1ed90084d118045690"
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