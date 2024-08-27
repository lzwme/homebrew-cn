class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.517.tar.gz"
  sha256 "458e6a7937c444d4356bec2ff6b9c64e2700ad56a5b694bf3ca220fdee06efee"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a7715c14f50e6545a44b46301deacbdb25b8108d42081071163e0574dee3535d"
    sha256 cellar: :any,                 arm64_ventura:  "a4e66fcbca112ad643fed0bbd65c9ed729ba4e50175b384be7abd614738fe880"
    sha256 cellar: :any,                 arm64_monterey: "ce419d066b51cbed8114e14f9de3362c4aa55524ccf4006644ba66146975b1dd"
    sha256 cellar: :any,                 sonoma:         "301837774a1acc09fd45ec5c2d1748e68a413689e03c6711fe87c829db26b1db"
    sha256 cellar: :any,                 ventura:        "0c0e90eb49ff7191f876e53fda945f6142acdef5a1b2a4995d2c8d0cb6a1e1c3"
    sha256 cellar: :any,                 monterey:       "d00cea9835f3aeb1811802eef22344035f5d2a93268a5801b7179b4ef9fcd718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0789e905bb9f61fe3501f8ee0da62b67ff465b2fdf8d4aea1a4e605433c38697"
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