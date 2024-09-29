class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.685.tar.gz"
  sha256 "a2c7c43fdc73f62d6b6105f5c52ee3d3af15840df148492e144cb4a9f9941172"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "11856405619c59a07ea6f1723b4c1fb8bfe0a1803aa56279187f8810df7f3bb6"
    sha256 cellar: :any,                 arm64_sonoma:  "ed456fc7ab8454ff691302191622eb0204b8a4fca553b58fa032323466235814"
    sha256 cellar: :any,                 arm64_ventura: "4f9869e3dc0ff5e6bbebf94541d632b7f191b4221267868db70e1767b118e95a"
    sha256 cellar: :any,                 sonoma:        "ea97932092fb3313d086ce3e25136c562729eac02d010922be07bbc3bdc2e9cb"
    sha256 cellar: :any,                 ventura:       "2e52f7c208700676b204f46bc9708eee789398475828d2d7d464475064e8b443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47bd79a697db1f22ecbb0e6ef012497695f50faf70c30115d9fde8c4baa8baf7"
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