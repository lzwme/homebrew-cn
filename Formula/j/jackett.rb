class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.450.tar.gz"
  sha256 "06027edfd6312dfa62628e303fdb8009639cf2ad79ab6ed9678b14bfe1809991"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53f950053d3b0b68718f174506041999953eec012cf72518f1d3f3f30a1df171"
    sha256 cellar: :any,                 arm64_ventura:  "34ba71d0b0576c3cfc43293af955989b33fa040a3b81c892a493964f898a1504"
    sha256 cellar: :any,                 arm64_monterey: "abd10844f6eef82166729de351132eb4209936c71a78a0b44ce1740dba7a3b83"
    sha256 cellar: :any,                 sonoma:         "cd23027243e154b33f5e242a2fb09e6b3763e3b0a664d6e8ac0575bd2fb82a74"
    sha256 cellar: :any,                 ventura:        "ada242d34c1be29fd12e2c776659cf9d208f474d9cd5e6a5af358be1650825e5"
    sha256 cellar: :any,                 monterey:       "35499475705a764e21a4361a1289cd4705717eb41c920fdc318f113e1749017e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8feb0585babd84c5c3b29607236164122ef77f6457604bd703c6a75fff00624"
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