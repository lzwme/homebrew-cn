class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.497.tar.gz"
  sha256 "71c4fe8abbcd4ce3b0a13973e2fafcc090043198e75409c739224f75611d2ba9"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e5feb2e0291c8eac1a0ab98648a7eb093a86bf34bb0dd2533c2fe20c9295826"
    sha256 cellar: :any,                 arm64_ventura:  "c435a0ab60c3fd19580a2fcfbac09cacaa72210637d9616f061e87419bda3242"
    sha256 cellar: :any,                 arm64_monterey: "c9d6f9f6607b5b4044025bbd8ff8139c9af778070ca0238fc4e75b1e9a666bfa"
    sha256 cellar: :any,                 sonoma:         "85ecec0e8f2743df2fa08b3fafcfedf5161cafc5e6a343702777669c6d7d822e"
    sha256 cellar: :any,                 ventura:        "1a39072ded6dda601ccd71c07d1ff572509e54225875f1f523d3558a0c8ad5b6"
    sha256 cellar: :any,                 monterey:       "f5bc4dab2c4d08fdad0df707b3bf255d3e069edb8832aae158cf54bae69e41c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8a8183ce37f04cf13dc5545b83585b9f7dffb92b70f702be937411304bab26d"
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