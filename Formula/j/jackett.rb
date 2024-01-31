class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1645.tar.gz"
  sha256 "836118e4dffa94a5dd2d22a75df82a041e53f6f4cc5b38bb9693756700ade69e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b1052743b70545d1c737c12d1f49effc702bd916ce98a4e2fb07d4b45c79fbbe"
    sha256 cellar: :any,                 arm64_monterey: "5f25d5a29fc39d16c3aefa80d01e77dda1dc1daf33d49d1eb0a5cc24ab23e7ac"
    sha256 cellar: :any,                 ventura:        "7a3d5bd2efd2a9f3b2b35ec187ce374ae39054a221e24a48a788d537f84dcaa2"
    sha256 cellar: :any,                 monterey:       "81b45b7cf59bebf607f480a97adbc7f79f86fd526c25eb1cbbb391628f170d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b8c8856933c5e6f5ba8be4d7a03623137ac67e99cc601db696baa6e5d59a275"
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