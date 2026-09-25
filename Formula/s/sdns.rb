class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://ghfast.top/https://github.com/semihalev/sdns/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "d7381dfb91a9931ced01dedab6e75ee70e674cc9cd8c353f86c5ab34a98bb417"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "550a893706f0c807441fb8c834a67890261434c84aba012d4049ae9c575c7908"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67809b7d390836b09ea4d30da3dc660970f74db31f833310dfb00a08e8fc7447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b79207da75826e6e3eba500f71bb0f02b16e1a2541f72f9c459d0cbf1af31f70"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "501d17b9c04aeb63595f45907ff2fc632c46b0b884de0175decd9f1a93d03062"
    sha256 cellar: :any,                 x86_64_linux:      "68cae94f9e5c86b9ea5887ae3783dae124464f453f0355abd3f76f294c9ae082"
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