class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1781.tar.gz"
  sha256 "04e19c0ec9b47d8e785177e0614a8544ef26dc66e56c1ba5cd6e82ca13486e45"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "05bc17f676c215659d60eb96abc0190fb021a223881a18e006159b3dd6d2ef5d"
    sha256 cellar: :any,                 arm64_monterey: "9f2610e035356276c1ad589c9f39436958f6a5887839301f57c9a38e88715a24"
    sha256 cellar: :any,                 ventura:        "d72e077666e9d8b0ef5282832fd0ed85ee2a45551eba93961929f7e0e5728501"
    sha256 cellar: :any,                 monterey:       "b9c2f876193935b3184a38c2a3501d29e9a5ea30869d3ce4729cc3f0d05393c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06a487968e883b31f56daac7b561a0f2322895c7583fb37bdab48ecb2319d358"
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