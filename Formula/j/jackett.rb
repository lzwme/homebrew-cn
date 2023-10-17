class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1025.tar.gz"
  sha256 "7dc43600b43d3b99903ca2b94deb4784bfccabbd47322f35508b0e0f0cd85053"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc8ef227196f4d3c8b77d22f3ed75d89b54d11fb79c8ed536947444ce5016e45"
    sha256 cellar: :any,                 arm64_monterey: "d55387b690888b99bf8d792c17bfdaae13b03521491263deb3142c18282c400a"
    sha256 cellar: :any,                 ventura:        "c3c37fdd14b0ce91f04ac9facad14a939aa8d044c9c584ef831a918014d51504"
    sha256 cellar: :any,                 monterey:       "2b93ea54363a02d0781f8931cc4a4d2fb07508e3089c05da196a003e6c58b726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c1bd6d4ba3d366c0d0a636e9570b7a2427b797938a8497f95f7d170dd7f816"
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
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end