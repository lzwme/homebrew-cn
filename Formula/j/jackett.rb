class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.538.tar.gz"
  sha256 "998e302695eb9728c477b326efdecff95ee406912bb8db052d3621f0d7512c97"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a6b54442e77657102aa1bc7a0d96468124fe3d55743577eb3a9f75f6d793114"
    sha256 cellar: :any,                 arm64_ventura:  "8af891ad87f12d6c13cc4a6bd922d880163f1f3086d1db6ad2a0442886028d30"
    sha256 cellar: :any,                 arm64_monterey: "7945507c59b2c27123d5f805d4e35552ec8260fe5e5c5ff65d06824a62707868"
    sha256 cellar: :any,                 sonoma:         "2ec54508e0daf6cb8505d401b130d4b0675f85523836a3b0b593eabb5b79e9f2"
    sha256 cellar: :any,                 ventura:        "383616d6f412af049eb254948ca0da2ed1ac4547c4441c72525bae69f146410d"
    sha256 cellar: :any,                 monterey:       "caf99afa881e1c1638d16dc51d981452c9e27c47b67c3d259331ca23f90044ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "979c4760f5ba8bfee6c801e0ed59ce33af3f741ece4c173790ad14c4a2a48426"
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