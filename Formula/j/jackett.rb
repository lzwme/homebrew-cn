class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.154.tar.gz"
  sha256 "71dde9442471f933b75610dc2da68c1ae7585a7f64137ddd205b10287197bbf6"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e8aa73868f2b8c5beef4380784bd194d5f020409ded5a9b7d8dc4bb424674585"
    sha256 cellar: :any,                 arm64_ventura:  "85088447f4beda345e5bca129a765cb0626aecfc9d3892b31f54774ec583fc74"
    sha256 cellar: :any,                 arm64_monterey: "b67241d6a4b1ae1c2a3704f2a95b10e9ff428b07468edbdde7338b4f1aef8677"
    sha256 cellar: :any,                 sonoma:         "107b2076851388ba8a14fa5ddd45107e062081b5a44c2b749ac2a947e1b15054"
    sha256 cellar: :any,                 ventura:        "bd8b8ae33634694a84f120446e96781ffe3490a24141c887a98946ad9600cc19"
    sha256 cellar: :any,                 monterey:       "a3a95636e7eff83a9e11ac46b3e837b09068595c71f63597df156ed80cfbfe4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "116ccf0c7fdd8ef8c1ab7848a3c6608f318310dcaf0aff9b3e5aeb662c4809a8"
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