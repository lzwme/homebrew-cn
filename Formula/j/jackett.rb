class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1764.tar.gz"
  sha256 "9678995be5c55c29535b00b8d3089d5ebfbb4db6b636186f41d1136de824e28b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cfb9b91eeed06ca05ec5498b42503978548c8abd6c4d4a58cf51a3d216f4c032"
    sha256 cellar: :any,                 arm64_monterey: "0ebe99defbfe40119f4af62ebd403d88635ff7908c65fad7fdde9431d6e5f570"
    sha256 cellar: :any,                 ventura:        "bf47fd0cbb225b4eba7b4e058c7102930cb8b9d912eaab351e41dc8cb0e1e8a0"
    sha256 cellar: :any,                 monterey:       "4f0e57833a17365c489ddd45b470debdc66045b50a059561dcc0a08168742bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cc346d32560d4408a1caadeeeeb7d397862e23ded388322e2e85b3b958f5515"
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