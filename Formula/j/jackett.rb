class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.703.tar.gz"
  sha256 "2b7993b74fb0bc298447088716724a0cbbfc9a3efb486f95c8f2775da8bf70c7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b3b89510934f44f2ff5bcb4e77c465a52de69880d61ad129c01b424c36d0bd6"
    sha256 cellar: :any,                 arm64_sonoma:  "38076c3543534d0cadcd7484cf71955c830f19b1ceba108c09e83deac17bfd2f"
    sha256 cellar: :any,                 arm64_ventura: "f5f6e3423841dfb60d0e1912e7f76cc51dbbbac09be5896702c6e7ede8deea3c"
    sha256 cellar: :any,                 sonoma:        "0858a8f5d72c8d3e9782114c3c03e33eed9e71c52515c6ed64499c1d33d24c56"
    sha256 cellar: :any,                 ventura:       "103ab15b254dbf7657d2aa702dbfb6f3a4965816c497510af49520780357dad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "354f29be9824fc1d99f783e3dc939f7155a75babdc2dc7e4b1e669fce595ccea"
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