class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1680.tar.gz"
  sha256 "dd0b7701c1439d8cee75f507d76df080283bb6d7b9fb92e3da47c4553135a85e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "976a72bffedcb034c1d315b2d87295aeeb621c3fb752c658fc055a05586cfcf6"
    sha256 cellar: :any,                 arm64_monterey: "a9dc35cb2fd9472529d7979958c4092f27bbe87935eea3d6f0128a1306becb4d"
    sha256 cellar: :any,                 ventura:        "5827b9497a00becb1d3f2b555942750b576a9e28e5859419f780843ba45222b9"
    sha256 cellar: :any,                 monterey:       "5a85a6fed07789cda58d77d40dfc0b4ed935edb85f9c1ee1d26249940c79c5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5147b24f683dbcd56c388789617d0db43bca449316ba2ed678c74403ae926df"
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