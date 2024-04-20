class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2414.tar.gz"
  sha256 "ec9935372a4d5a0bd58ca0c6d710179dce8460d6b00018badf715d3e60a5066d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "81c081fb9ebfeb7169f735fa321b5662b36e0402d5c19d6792f49e75d04855af"
    sha256 cellar: :any,                 arm64_monterey: "0ae715f15f5cc229d96c6eeca8e8fdf1a47a43ea443924b7d41838323883a7bc"
    sha256 cellar: :any,                 ventura:        "bf6e8a25d088a88ca6461fa4e5af1856581596be1ac0bd0e0566a9dfd594b6a8"
    sha256 cellar: :any,                 monterey:       "d270f4135dd0737878c575c54573ef3bcbf440ca545a32ef835064debc0b584b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfe2e1de827302e983a0d0123fcf22a8838914300baf705659912e47a218db87"
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