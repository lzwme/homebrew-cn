class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.994.tar.gz"
  sha256 "eceefe837c02d914d303862575ef32e65d3f85ba102bccd9ee61b93f5444834c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8fa3524a95e7a74f02c507273f382c0bb4a849ff60314bc5971daeeab3db52d1"
    sha256 cellar: :any,                 arm64_sonoma:  "87a021ee38d2ba7ec4b1da802ff97e836da4666daf132d344d79188d8ecbf9a9"
    sha256 cellar: :any,                 arm64_ventura: "58665a8a50bdcc50a0d4c20b271132d2025b2fa674edc2b0c48ae8b3cef1a28b"
    sha256 cellar: :any,                 ventura:       "bc5582714d6dd595455256039716e2a16630e567b5cb35c085b336e86e0f8c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89945c503b6a7338775066cfb472b42af8974c64192bc229a87d586513a0dadf"
  end

  depends_on "dotnet@8"

  def install
    dotnet = Formula["dotnet@8"]
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