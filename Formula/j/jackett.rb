class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1797.tar.gz"
  sha256 "8215b672a28a6e56f77f981d2566026c02eae51d139ba2440662aedeea9fa341"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7230f300b6bfc3d8318a1252bd5ade332ba20bdc26f004a27c53f878c1b77a8a"
    sha256 cellar: :any,                 arm64_monterey: "3cf676d0e2de18f1733d357115f9ccead01b41a2156cd50c26af2bc9d36dff6d"
    sha256 cellar: :any,                 ventura:        "9f48d8eb195f96e833d706d75d88cc21af9fc1edef8be4ae6c8d7514be9620ea"
    sha256 cellar: :any,                 monterey:       "3917e746fd5f90da0e85621442a45acd21fa43b1962093bf2f2ff3bae403a596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5f65d65eec78848162c24e7dcffdd8e31cf81e9d95e26575f33b0f21d9cf80a"
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