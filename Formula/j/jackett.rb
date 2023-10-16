class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1018.tar.gz"
  sha256 "29c2d1fb72ee0b7818bdde883e65cfeb0c96914bc247944c424335e56d962d51"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "50714c5a1ae480a368af7ce5a9160e4362c8d1fe7979fd2ce83acc878e98cff7"
    sha256 cellar: :any,                 arm64_monterey: "c246a79a9bfeaa92bbb5dfaf345e8e5fba60ac8554ba122d74eccb312091ed38"
    sha256 cellar: :any,                 ventura:        "2aab3fc3d6aa6d27a904f0678e67be3cd4ba96fc52ede36982f6a9207733cf26"
    sha256 cellar: :any,                 monterey:       "772d73f62b0c541c6c977fe2e7fc92d7e5e9ad4ba76116ee85d9aee79ab86ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c41af35375cb737d2fbedbef3d68d2fb73107ff55cae24cdcc4bc867bbd7787"
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