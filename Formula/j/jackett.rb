class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.635.tar.gz"
  sha256 "c43a78005941e477b06a1f574ff91382e04b33832280b0a6f45838b33cd9851f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "6a212645e959b9b9507284b40adb593e420e089456f3e23f0a8be771b73f8504"
    sha256 cellar: :any,                 arm64_ventura: "631e1e3726ae22c945df40fb38d13e6d139fb9d4e1b5993879dc4d2ffd5e1951"
    sha256 cellar: :any,                 sonoma:        "66fb1a75d2407bc1ce583d1c176c0aabc9d94c3250a3849b953414f9d65b9863"
    sha256 cellar: :any,                 ventura:       "ebfefdc8a5c65bd4ee4084b44faabfa44a069d7f3e3a0d9a902d7b1ea983b1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5624ac1854884ca078bf5d9240a6c098c07188613826ae80039eef3f9e2e5450"
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