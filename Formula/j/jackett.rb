class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.806.tar.gz"
  sha256 "497ab1b86a3795b0ee599233df081cc09a1998029e2f2fa047c016a25334d10e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68b8ba28549231de04b16a6ca7c39f4810b441f32dac7c4362e84e144bf94471"
    sha256 cellar: :any,                 arm64_sonoma:  "539e8e4fa783dcc8ce1e52edb3bad1d32cb32e715d4aeb703fc4743e5b835254"
    sha256 cellar: :any,                 arm64_ventura: "871e490d335fbd45d875fcfed19e573366f70283c9dd88d56024d612a35040f8"
    sha256 cellar: :any,                 sonoma:        "55b4940052f68b929473e476e2502e927321a9d8877f2aeb79546379c7c37ebd"
    sha256 cellar: :any,                 ventura:       "bb29ba6b3e738cfd5b890721342f42646891c9ad36b80be3ed55f0aa8b1b3b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcd831bc12e01ac8c5cc929a27d5f04805d5b93aa1af2056e8e30df7ee7e9c9c"
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