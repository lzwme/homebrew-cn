class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.361.tar.gz"
  sha256 "4673e90c243299058a5527428a066a40e2886aee5001db081f16a86a1a6a1d9f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1677c6e9e71c7b0aeebf15e3beab374b14f0cfe274b19b96209aaf41d31b58fa"
    sha256 cellar: :any,                 arm64_ventura:  "cb2bca16c8277827b64bb376cfb93eca26c5b555f774309cd7ddc1947767cc23"
    sha256 cellar: :any,                 arm64_monterey: "fd9043dc8a579e2168557ced5e3ca065260cdff1fa4cdc5dc09f0dc78bb154ac"
    sha256 cellar: :any,                 sonoma:         "efa39459c511d4f7027ebda92f53ce76a56a2fbfd6d1ae23dea066613fb941af"
    sha256 cellar: :any,                 ventura:        "9bb5b44ea0e87265e8fe0efb1456c453279016cc4c583e656c912bb32d608855"
    sha256 cellar: :any,                 monterey:       "09b4e69397c7be4469795406b705880af7df24fbf2118b346a8427fc9f978033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b110c3be702da35cb073536c2b4d791b468999d72fef955c8536adebf099f127"
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