class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4032.tar.gz"
  sha256 "6808e4f69eb492acba10f5e6da43bcac3ac9205ea9fc17aa1306c1342dd8cb16"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "380e0bbdae28b66bee3330df3f3d29068ab0de83a08ce362a35d68e4a3b42ab2"
    sha256 cellar: :any,                 arm64_monterey: "618a9f60d1a6423d28bef8fa6a4411340ffac7ce6df51eb688a934e5c5846118"
    sha256 cellar: :any,                 arm64_big_sur:  "921fd4ae476e046cb05cfda33f968eec6d77630196ea88f92baa22480756d8f9"
    sha256 cellar: :any,                 ventura:        "60c28161ab489bb7881fee5eed76d0271d208ead5d7c2971d64c5f4eef6c467c"
    sha256 cellar: :any,                 monterey:       "6245585e33769a3d91610b61d1cc041457b7af98958812a9be0ff595d18cdb5d"
    sha256 cellar: :any,                 big_sur:        "83d74881c79658fc96f35dc3cfc06be5a6b54b147bb0af28ae7e5b693aaa04c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3263a63ccfc3adaaf20f3eb59eb11be161477e3f6fe06cbbe9f6e642659f28b5"
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
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end