class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.66.tar.gz"
  sha256 "ca69506b214f04413814ee091029fa34f5c4bd9fc4915b61ed544b81ddea0a14"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2f31257a0be662bfe7d50586da9ce3c645f0cd80cb8583481f3187c8006f04d7"
    sha256 cellar: :any,                 arm64_ventura:  "e245c0c9eca5360f989a6d125f6789e35f6bca77b83a541d604a0291f949cd27"
    sha256 cellar: :any,                 arm64_monterey: "231f40e6714effabef99ecb8c74e300ef5cca3e6101706a7aca74e1c87ea5998"
    sha256 cellar: :any,                 sonoma:         "6fb3a7d93bf375bb59db5fac5a6063aa6d8c4994f889de0fa91dfca4992bf9cb"
    sha256 cellar: :any,                 ventura:        "20c8b6650012aa468111fa94d27aa4608242eae5a68bf971f69a2f98965ba1e5"
    sha256 cellar: :any,                 monterey:       "fa9a0c28427e2a00eb6e34c2d2a82655a319793c22a9df4000f954c11aa8bb0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea4a0314894c9cf40e608358ae71ce1a29b7f260e87d8b1a574d83f72e580f1"
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