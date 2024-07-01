class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.233.tar.gz"
  sha256 "b7d83b470daba044e75d2f6909a4b7345d35e0ac9b119c4e42da20d7e1168d98"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab694f87d1f202c7869610269471d26e617dfbf96153a9544a1cce575e0ae889"
    sha256 cellar: :any,                 arm64_ventura:  "f7d96b68c896166113cc23e587835b0382938648dc92db285e49ccb30d7dfa3b"
    sha256 cellar: :any,                 arm64_monterey: "0360074ee95fd154547e326bb460230a0ce0e576ca493a203da46c75a0afad46"
    sha256 cellar: :any,                 sonoma:         "15b935cd9be1bfe18154f0327b14d8d7908c5ffc789bea604082ed87d554376b"
    sha256 cellar: :any,                 ventura:        "f60c166be40556e088392a7dd7ee1168cfc3377e5e1084a67d996659363668c4"
    sha256 cellar: :any,                 monterey:       "baaf6df7442c0387b5a5aca60c9f2ed7ea1d371339f90ce4886fec4707cbadca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4509dd3bb74dcb01433856e9548802c89adc6e461792ef6514f847390064bf2a"
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