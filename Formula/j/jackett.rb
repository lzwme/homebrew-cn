class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2354.tar.gz"
  sha256 "57cc8edf344c1783306bb8784060bef451cf86605acd796fd3f805e6ff1aa3dc"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af84132cc43c643841e54f86625651272571803952b6d57d7d8ec3f26823b6b4"
    sha256 cellar: :any,                 arm64_monterey: "2aa8bcc8df4c49934e9e623eee902aaefc153ff0f01c82c91c0a5527c3ef317e"
    sha256 cellar: :any,                 ventura:        "6e4541d229412499f8c7175b534bc2cdb710c43687fc686fcf98df17b5d6aa05"
    sha256 cellar: :any,                 monterey:       "197e09667bc0a9b1bc96cdb2d33c26a88ca6ac16c8f9f5f5dcfd099571b01b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a42245907dbc7e289631449dbc4fedf8d3f9d21381732f59aff60aade8a03165"
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
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end