class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.676.tar.gz"
  sha256 "31085460e773f885139a0cdbdc8839d34c2bc51de15190344cd5910ae65fddd3"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78d765e52262f1588e07a7b8ebc07f37b511cf503a9357e984c565bb12d88674"
    sha256 cellar: :any,                 arm64_sonoma:  "c797a016a40063750f20dd5f523032fa7b53882b5c912205b8cfa4f34e8e6c81"
    sha256 cellar: :any,                 arm64_ventura: "7d7cb78aed5d1006beee49af6f17213cf3e88b5c63f1d68e627bafd596c18461"
    sha256 cellar: :any,                 sonoma:        "da5cbae7f2d9168061180d54bb3e877a2e4b4d89eaa31cf39dbdf97c0f6c185b"
    sha256 cellar: :any,                 ventura:       "a1ebd4ded5db9539f2c99207f972744e14f1e4d942e58b09e4a9ada83c492ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1886bcc44bafd7c6ac3e48a6cdf13947c083b7c4716e2ab184aeb205cffc79f9"
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