class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.583.tar.gz"
  sha256 "0a57d0a71d48afd48dfe91bb52a69fe3399d91e2bb8641c6635d4ebcbc15cc78"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "917a7fd278672c155d550b3422d55d258a4749fb229dbdf8f9a485fb40f582c4"
    sha256 cellar: :any,                 arm64_ventura:  "7b71c2d5cb2a62fe1216394af3dfcb9a8498aa3ee06666aaa99f0328a7b2751f"
    sha256 cellar: :any,                 arm64_monterey: "24adec95f320a493652ccafb5623e623cfe0d8c369a83e5ca361d7787eb84b0e"
    sha256 cellar: :any,                 sonoma:         "625d9b47c0d0d53a700c6abc1d7de4d3278263ba0850a2e5d25b8cc8fd7ca95d"
    sha256 cellar: :any,                 ventura:        "afa02d96955c063be63e92944a45ef850a234a4f19308efbe1f5ee5a68c535f3"
    sha256 cellar: :any,                 monterey:       "02180a3eb753603bcffa7a03e2d3fb150ebc5ed6ab9fe0931300028c54cc65ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1190ba7c3b1a7c33d383e05ada76d3bb749cb1a7d2722dcbebf002b47f7e7cd1"
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