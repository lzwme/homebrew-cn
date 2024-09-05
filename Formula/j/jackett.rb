class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.559.tar.gz"
  sha256 "944753be2d5d096db2842e5ae6627a2f3eb05a39566b528b6d86fb56de8afe70"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b5fb51f483b7029a4769792c55daa3bc9beba9147b643f988e7d2a5726c26efb"
    sha256 cellar: :any,                 arm64_ventura:  "4a0f528f1acfe4739d5f024db6ddb31af701e88c1fd051ba4d034f26a306b8ed"
    sha256 cellar: :any,                 arm64_monterey: "3c56ef8e346939acf6ac06c6dc261c070e81ffaaf391513e35a934bede510d3d"
    sha256 cellar: :any,                 sonoma:         "d5cbcf52bf8e92f0694130ecec2d61b1b9117e22522195c0c2613c7717de5e13"
    sha256 cellar: :any,                 ventura:        "6a6bd8d0cb1edcb7d099c47531d6482768e30a3ca5a7f6ab95e82ae13ebcc045"
    sha256 cellar: :any,                 monterey:       "0ba5fe23dfac9d26edbaee469b24d354d96a5c1af00fb7e46654f44c1df4b207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1dc5fd412b0a1cd5119871795963649768cb337458271427c965771dc56e53f"
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