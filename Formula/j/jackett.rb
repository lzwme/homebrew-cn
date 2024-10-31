class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.862.tar.gz"
  sha256 "636081893a237675a09e4b9e5cf7854af75bb52b380acaef172e4a0fd0d67fbd"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da4b5c66389d0d5ac4783235df3318e7b36dec50075bcd83a42b1f2b5cca2d80"
    sha256 cellar: :any,                 arm64_sonoma:  "e52251ba58c65308bccee3373136b5265f3996670aab0b1368eb6aef6975b734"
    sha256 cellar: :any,                 arm64_ventura: "f0f3958582ff6802a1b0e31d6ae45637d62ee0fb3ef4fa0d587204dcb7ad7a5c"
    sha256 cellar: :any,                 sonoma:        "5fc07d4ef477ccc9f4933e506253fe2dad93b1b963c1d96f3647c8ec82755302"
    sha256 cellar: :any,                 ventura:       "9d153f73772ef9b7af0189052eb0851d3eef111819e8655b9b18ce4d6d728e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eabba390f6584ab594d4a127084e2e88239cde180507da74a13231bfc5ad8cf1"
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