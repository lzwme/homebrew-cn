class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://ghfast.top/https://github.com/semihalev/sdns/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "22b2a674276c939f70ef0bc3983001c9ba7a88c758dc640edd154ae2a707795d"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf60d7bd5f207227f6301d3b2f2cb1575368771565b56997895d1d811036e77f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c91b710998b5f035644898af91d2f7e12958cf6c7e7b5af6b5a0bd57f5f2748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7ce9acbfa2492f9c826b396703cfdae098717965c5b490258d94aa818bbf6fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e96e040a0f827b077c5aa849cad0850f66816a551608f1bbaffc5ca96b2c5869"
    sha256 cellar: :any,                 x86_64_linux:      "14561d028ad7657a136ebbbac4b5e3f53636924e87eefa00d5b0cc44668f0ee0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "--config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    require "open3"
    stdout, = Open3.capture3(bin/"sdns", "--config", testpath/"sdns.conf", "--test")
    assert_match "Default config file generated", stdout
    assert_path_exists testpath/"sdns.conf"
  end
end