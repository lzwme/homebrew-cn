class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.698.tar.gz"
  sha256 "701fa800b66f94a0f71eedfe8756806459765ea4449030a7b02b4e0ac313b030"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dbfa7a043061046d14fc70a8ffe69ce4d731608ad58b375665c846b056b8b9cc"
    sha256 cellar: :any,                 arm64_sonoma:  "c2aef1c60d48ad2972af404e20e690d3d89957b6c5c5db1eb92ef61b957c7ccd"
    sha256 cellar: :any,                 arm64_ventura: "d79855c1718d126ceb89d4bb3ba5762f2bce1a3f69622d355217d1a4750d782e"
    sha256 cellar: :any,                 sonoma:        "281c7afb2e133e81bb8566f01beecef470c65a5fb1832db239fbdab85c4325e3"
    sha256 cellar: :any,                 ventura:       "470632e61613d369253412bb641446f583bb18140597505584ea355591def9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "328f5bc4db7aa7e03c72d07be364b0fdd0f1f6f4ed4ecef29fa3a35a42c049f3"
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
      exec bin"jackett", "-d", testpath, "-p", port.to_s
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