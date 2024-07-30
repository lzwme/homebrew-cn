class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.391.tar.gz"
  sha256 "8e387210f040d8259aeda5ab7b9fe122778cb74d1845d0499488c4c3baaa5b38"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "160e47d2ce9ffcf621f71a3396392aef21790e9cbedfc33be59245f43b5030d2"
    sha256 cellar: :any,                 arm64_ventura:  "34e18d77ab06fe9b0bcb5ca9a25e25c6dd230c3fa19b085ca2fbce966686311a"
    sha256 cellar: :any,                 arm64_monterey: "e2dc1d22ae8dc8e3063e1f0c4f4d84fa16980a5e264ec0771098cf21c1b25c7a"
    sha256 cellar: :any,                 sonoma:         "1584997b2c17cff48c55fd1ebb46c8fc2ba8f0b56425fd3900d05687637a8bf6"
    sha256 cellar: :any,                 ventura:        "d59a9e7af7256d4ea94944a571397372f70724245c6d31cfa6302ef6d0de7304"
    sha256 cellar: :any,                 monterey:       "25c69ddcebe767f742c46c371e08736e12db1bb3e42f9b4bde6d9d592cb8bce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "541bc2452871ec1ec54f5ccc5568c84b8d9b064ea52204fc45b1a0956f038787"
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