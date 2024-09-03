class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.549.tar.gz"
  sha256 "5e2764ebd566c8f58ce78ada27c8b71f7a5c4c01d54478a29e19a5b987858589"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e351b6242d23a6b0d6e45f4b2d2cef392f28c5428413e4fcaa0c6020fcc0fd62"
    sha256 cellar: :any,                 arm64_ventura:  "058e8f1f8e6c46671c2000f6c7eba1b37801970f0df6a52be8f7f8754b527321"
    sha256 cellar: :any,                 arm64_monterey: "ebdaf7e7d4eace8c0ed9891a8dc9a9a61777844ac1bac36850acb9a9d90a5ed2"
    sha256 cellar: :any,                 sonoma:         "4d676b66cf32d89f7cea8dd57f4bc560ae0e209bee7a42288f812099ca6d15b9"
    sha256 cellar: :any,                 ventura:        "235c39b723b400c5fe8f4f06d0210637105a694c3cc6637c5dffc59f4f13e212"
    sha256 cellar: :any,                 monterey:       "991ef3dcd83d2f821856802d8b5b8e052b36cbcdb6c2749f8a6056e68fb95314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc5c627aaa9e80cb376cd28b595ee644e282c75ffcf76e47a36cf744da35099e"
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