class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.207.tar.gz"
  sha256 "80c8fb7345c39e37e665fe29ed6fbefbde8368796bca62e57779d2bb444eca69"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e270ca4715a95f10163c4242f218006c1b89e6c2fbad1871a77b240bb5ffb9c6"
    sha256 cellar: :any,                 arm64_ventura:  "fa01feef534a509d0f5161300b1b5c3c35e869577bc0dced51375b914c6bc05e"
    sha256 cellar: :any,                 arm64_monterey: "680110c7c9b49b683d45908cb9e71f1cccfbf355e91d4103f55d8465317d83c9"
    sha256 cellar: :any,                 sonoma:         "6abfd43cd00cf6192c7d63ffe18d16e57a75777a8d2efb5cefcf1b0c9469eeb6"
    sha256 cellar: :any,                 ventura:        "298b1a80d20658eba4c8eeb2e22b154c1c8fb2a1451dd9e9b23672c1635609a7"
    sha256 cellar: :any,                 monterey:       "dc8cc10ddbbafe73b381142e55adae10c86848b595ad8b1c6b490485ff2b7171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbd5326930667ef823a93b6369a68cca6c060814f8a65276a7d560cec807cf87"
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