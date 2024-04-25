class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2446.tar.gz"
  sha256 "3600e89aea4d762fd1e593a8d5803ad9166e1f38868c83ea08af5bc1e86c4619"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f87c338b350dfffb1b0b14cd690aebf7877d2480e48b81cecd0fb02d30a9d71"
    sha256 cellar: :any,                 arm64_monterey: "decd075f53a9e36b25b1313b0f2c31905fa54537a8c898c548c7e62802d35821"
    sha256 cellar: :any,                 ventura:        "cee48b3d471fa51708066f2d68879ea8a19206946c107880f976bd71f609a73b"
    sha256 cellar: :any,                 monterey:       "92322e5f2279ec8927fb463a2b43cdd26c5c358fc2b286499a5ad66e40261567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52ea76fffa721b505f4ad2c4fef4bcd3861141ddde92332428ec266d27a222b5"
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
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end