class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1424.tar.gz"
  sha256 "3e703f258ae02583d0a0c6e40d48fb2ded42c5d9e346875fdc527bbd8310eedf"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56f5369b18db0c9a015efe53e24eebb99abb057d49735355c3678f620ad637d4"
    sha256 cellar: :any,                 arm64_monterey: "044ebfbb2a2a6c3db560c267aa266282718fdc4d2069f1d935eae9a1c27d0e23"
    sha256 cellar: :any,                 ventura:        "02c7b462a997b7be90b1082a9d5af9e1d561c66f7b1ed27d05fb8eeb55fa5a6d"
    sha256 cellar: :any,                 monterey:       "57b052e2bfb618713ce9414255957080f0be9bb6405428c3529895024973f0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "829007a5f6f8444c06ac351409eb9654085bf34b02cca83318fb058d00c4b7ed"
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