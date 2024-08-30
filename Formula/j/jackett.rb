class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.534.tar.gz"
  sha256 "0a99ec0df54e62cbc27e75e44732ceb33bbb133f643754a393c31e51dd9152fa"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abd445aaf24dada5e8a865b83223df27d80df166279b0a54923492c5c0cdfa97"
    sha256 cellar: :any,                 arm64_ventura:  "04afb70bf16466489bd161a7afc26f57f8ee126054f626da4f3861b45b75d5d9"
    sha256 cellar: :any,                 arm64_monterey: "44fd7a46c99146fa45feadf8b88532f08cb261e268b67a78552964a75883d12f"
    sha256 cellar: :any,                 sonoma:         "d4791d53926a5daee53678c3ff173a0e0d574787e86afd1f6f5694324022a1d7"
    sha256 cellar: :any,                 ventura:        "9b9d5cd1c89c09e350587bdd8f7a0c4a8d64c3f98ad4e9959178cd2c656a4781"
    sha256 cellar: :any,                 monterey:       "a42f5a95c25cd2075b55f32cb1d80adbff6c11e15241e175874d78b3bfc38c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d59439fd6ac30d4d5e95b895ecc4f6c184b58680b2a157ac1d07300740d1680"
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