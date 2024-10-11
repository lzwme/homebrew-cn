class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.756.tar.gz"
  sha256 "fbeeae014e94e280af15836dff8f483a0a9d8005294363c12a5fedced0ea6b6e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47ffd1d67ef74141a7ba5898fdc88d83316c76ef036fdd489040856caca85447"
    sha256 cellar: :any,                 arm64_sonoma:  "749f90e7924f1f803711e49ddb57bd00890c5ba2ead3215618ab5b5880ab72c3"
    sha256 cellar: :any,                 arm64_ventura: "3c9127696ff60bcf45fc8cf48d8c935cd79101eac2d1e519a0b97973ba149748"
    sha256 cellar: :any,                 sonoma:        "d1580983b6173251d2554b0ffe224409dc5ae164a120e4ed88aee48c73ec78c7"
    sha256 cellar: :any,                 ventura:       "92d02d560b79ec77c34ade330d6f81141b1a221c7cc3dc0413b7afb87c5e70dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b599a699d7c3455008c3f02a6396040b2182ec0095e929b5629a0021df13179"
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