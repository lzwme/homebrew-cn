class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.275.tar.gz"
  sha256 "fd40d8fc42d6cb298506c0a9a5f6e7fb695c94c5232e48d2f038c0b8d082fb3e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "836ecae2b5922b1fcb96cb8df4f34fc6911d71a2d712da0574fef0bbe7dbf32f"
    sha256 cellar: :any,                 arm64_ventura:  "8dc45569de4b7ac95c27f3568ff6817997c9e003eab34fbbd2a528c766bc869b"
    sha256 cellar: :any,                 arm64_monterey: "b8bac04242c2d2ff9ff66b64d33593f3f0f86030a3a9c33cca02ed11c0b2e287"
    sha256 cellar: :any,                 sonoma:         "7f8684bb8dbda708227269900107738a80f0e842fac487929f6e26b9a8228fa4"
    sha256 cellar: :any,                 ventura:        "d741ec3ca46a268a67d4d86ad4b5f277160e8a2fbfaaf84b81d4df9311808cb0"
    sha256 cellar: :any,                 monterey:       "ff5e3c0b2294fa6a40caeeef6caba930d2bbf6d5ae872fc509c9c3f1c4128362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d9efaceaf75a7b9d5cb551581870f47e88ed42a569fd7c54f6f6be0d33fbb3"
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