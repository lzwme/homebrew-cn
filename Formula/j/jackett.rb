class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.439.tar.gz"
  sha256 "4581e8f7aae9e04d20405c7d23fa38a29773fb39e14904c375cbe063bf395d4e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cfc85cbd3fa708c82775de52054d7e980012aa08b89bedd247c3d4a43100a0e8"
    sha256 cellar: :any,                 arm64_ventura:  "5176543ca20bf57e249283011549693d4cd3bdb186197758a56919b46de4f63f"
    sha256 cellar: :any,                 arm64_monterey: "6bb7226fb26df1ad4535cb5bc46917e529a61198a837ddde62d7228b998493c7"
    sha256 cellar: :any,                 sonoma:         "f9b8d3a17f9b41fd02516ec57442992eaa1e231e8a8ef324a58bf408c4a6d941"
    sha256 cellar: :any,                 ventura:        "98c5e9ac5ca5b03523c21e17a1f42cc23adc5b219cb4515d9938c6afb3027e41"
    sha256 cellar: :any,                 monterey:       "eaca6451e531c7a4e5ddb05e917ebdd2afef5f5a8f002809f09ae10db09dac2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "021eabb75d935940872f9e0568c2ff6de933f008f9969482ad8839ede5266963"
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