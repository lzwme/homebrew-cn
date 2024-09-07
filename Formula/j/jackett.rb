class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.565.tar.gz"
  sha256 "dbf380281db6846fbf8265170561e4e2a2d30c5f36067e5a963a0aacbf6a33fb"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8e9b7d8d0dc6bfa75dccfedd417612f65278547c8845bd7f9118c6004cc2f56"
    sha256 cellar: :any,                 arm64_ventura:  "68bbb443049f324d41f46c56ec29de1914a7ff40a73e0b83713701044c709ba9"
    sha256 cellar: :any,                 arm64_monterey: "374484078c526005721b42644c74728ad04778362175855243d7c409cca0598e"
    sha256 cellar: :any,                 sonoma:         "3f49b0a4f1be38dfdc4fb9478dbcec66d10d3d4f55c27e2656f1b1295709e71d"
    sha256 cellar: :any,                 ventura:        "670eaf4a8f2a20b927ed7023c7b074214507054676f9d956a9e59fa77fb6dc52"
    sha256 cellar: :any,                 monterey:       "95648ec9177f297aec0229da8ff8617b1b0075c3f03fb5f05343c32db0ce49d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be33a247bffea9f8dc036ffefd8ba6c0d8fe598c4fbda7669ea424f17bcd9c33"
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