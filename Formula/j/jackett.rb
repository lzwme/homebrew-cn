class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.468.tar.gz"
  sha256 "6a189ac3e5f1a4e69cb4491e21f65dd9332fc4878cff2a44dba13ebf9e4debdc"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "225256b3fa8269360638dab65f9f8ec94fbfb0513e74d8e302e27c2bf5d007b9"
    sha256 cellar: :any,                 arm64_ventura:  "8b0fd6ec6003bfd78f0b3e2c8eac6c1ab9254e51323686069a0121767275a4af"
    sha256 cellar: :any,                 arm64_monterey: "eb3d89c9820c8da8299608349a0cc7d05ae60281354033396d7e547ce0d0f1fc"
    sha256 cellar: :any,                 sonoma:         "46505aa968e35b7c46fabaeb9bd88e040c737d478a654a2819b75d977e67a450"
    sha256 cellar: :any,                 ventura:        "45f666c00d21c45eac46ede7c57f73fe54836faa666bad272f15e1ca0a2226a3"
    sha256 cellar: :any,                 monterey:       "52786c57d32b247a28517110fb9b74d691387489f1ba4b0c2fb95c512670cb67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb1d29d811db8bf8fda341aa0b5ade6e7153bb12188071775e5a7987de939ce9"
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