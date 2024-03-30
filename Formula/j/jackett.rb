class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2212.tar.gz"
  sha256 "2760dd13734a38266d26b248a155b8e499d796f91d8c1411934204add4b1927f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00faaefc08d6a6a0d5a71055ca9c4adc2b83f4a6775b22c5c96dd34e0ad96957"
    sha256 cellar: :any,                 arm64_monterey: "b7c72f70a6d1aa57a6ae69c8f1fad38904ad5b085bb4976ab28002537b4f5540"
    sha256 cellar: :any,                 ventura:        "5f7dce4de65eea590db1902f65ca4bc21031653162cbd879de5c7041389817e7"
    sha256 cellar: :any,                 monterey:       "b24342d54f16983b68bbd251b7104d0284c007fcca8bce01b3e71cd1ca3c561b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11b85ad4f5c442cd7acf07f57675701f81517565de16a4d49c7ce32800000666"
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