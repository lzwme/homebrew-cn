class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://gost.run/"
  url "https://ghfast.top/https://github.com/go-gost/gost/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "3b5241edbc69d9578a37b3e950cf02ca7a7dc2aa2f688457affc63d966b93012"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da885fa49264deff7fa2d3bdb3a3062b14608d54fc92331c1a40d7b4218e4507"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "358219237c979767327eeec904ba73d31de14418eaf06a3453560f78b4d1486c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8df080e90ba923bbc6e491fbc816a7d4c8c46e1c63df0a83fcb2290e9f92e930"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "075b8494afc19ab2b8843b5b233ea075a1efdd95504e1f92e914689fa7adafe9"
    sha256 cellar: :any,                 x86_64_linux:      "b7a36383fe1d3c812c497fe13f562f03e872ab4f3e681599342229634f89dae1"
  end

  depends_on "go" => :build

  conflicts_with "vulsio-gost", because: "both install `gost` binaries"

  # `test do` block runs a local proxy server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/gost"
    prefix.install "README_en.md"

    etc.install "gost.yml"
  end

  def caveats
    <<~EOS
      The config is installed to #{etc}/gost.yml.
    EOS
  end

  service do
    run [opt_bin/"gost", "-C", etc/"gost.yml"]
    keep_alive true
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    (testpath/"gost.yml").write <<~YAML
      services:
        - name: test
          addr: "#{bind_address}"
          handler:
            type: auto
          listener:
            type: tcp
    YAML
    pid = spawn bin/"gost", "-C", testpath/"gost.yml"
    sleep 2
    output = shell_output("curl --max-time 10 -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match(/Server: GitHub.com/i, output)

    output = shell_output("curl --max-time 10 -I --socks5-hostname #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match(/Server: GitHub.com/i, output)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end