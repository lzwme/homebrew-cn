class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1802.tar.gz"
  sha256 "fbdd6007e1b57b122491218c8a271e3866baeae6489ab499b6cc2e6906c06075"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8d4865a080b8bc59525ef3b5de02422fbc63a2589fcd0caeccba9f3707d48521"
    sha256 cellar: :any,                 arm64_monterey: "aabfe0c313b45638e74aea232ea36c146ae154cf24727376a36095f1abdba137"
    sha256 cellar: :any,                 ventura:        "b21f77214d053e22cbeb3cf4432a5561d9b528d8c3618d784d82eab1f62e47b6"
    sha256 cellar: :any,                 monterey:       "7f52967436ed52ee806a160f11ef2138ae3aad02e0fe8d22752e437e0d6ed9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0035d622b243d48483f980248f62fe4ae0de1355f731cfd5bf442b2cf7c47c3"
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