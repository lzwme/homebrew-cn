class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.581.tar.gz"
  sha256 "78f4a16c35915cc47c3bb13f621f70a905b0f069d7cdcd2dca755aff7ea054fe"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98e6ef9552c75ff61de759590436a01382ff2b9437eb4e61f7ede1db29b2a373"
    sha256 cellar: :any,                 arm64_ventura:  "518f20118f92bfd132a7af026a609ec1e60b1f67c3b1cbf53b3bab72daea636f"
    sha256 cellar: :any,                 arm64_monterey: "db73a7efec89766779e66b46f7182f220e514375c3557fd87199f66bf858d43b"
    sha256 cellar: :any,                 sonoma:         "ac09f41f4ce2f8c30e625dc331ab9f4349bf7ce8b397559cbcce69c13763f3ba"
    sha256 cellar: :any,                 ventura:        "2b1fc21049d3f9942b9dcc33edd78c843b81b6337c48eb9689e4219da358a41f"
    sha256 cellar: :any,                 monterey:       "e3cc0d2fcc46ebc9ba85db308dbfafc99f17a485d8414abdee72038e30b3a34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f64de174db78b88e4404f62909959d5593e8b5c2de72a0d6256250ee9f170f0"
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