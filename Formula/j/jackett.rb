class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1635.tar.gz"
  sha256 "b251e8e5aad7af82a0f30c588946801988e75bd91bf3f0d2c54f7cbe3f5f602a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8fd1d12ca0584305fd94a5775e6faf43148365b03f7b82759ce7363fa146701e"
    sha256 cellar: :any,                 arm64_monterey: "8736b413e333aefb817ab7091d0a6bf5dcfa1d015cf16a3f29d093d71e62fe2d"
    sha256 cellar: :any,                 ventura:        "d16e2770cbc56a3dea051bf6bb0482a1aa0da5bb09e14c495c266f59edb87b0f"
    sha256 cellar: :any,                 monterey:       "aeb08a02e6bffa9613bd831fb24abccb62f2d23d35fca8f131f54bd65243dda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18013550945b13da86c3bb1080909f9c10d2f2f1151424786a7000d7448c3871"
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