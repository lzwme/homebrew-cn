class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://ghfast.top/https://github.com/semihalev/sdns/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "172fce58fbadec5e0e5c2f471a6b32ae2d88c1cf074de4f3036fa0cfbd931247"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ce50e82bd1a885d03ef47570b107e302110e53825b52c09c37696c99f5f3f80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ded4941236e116d796e82020f94695fff25184fdb8fe521873c371cc34678cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c015ae4f4a459dff474a948858960cb7a28005621651bb0ee48d5bbf4b18c75f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3012c58c215d1785e18155aca9927e85ac044c01e0575522b8b70c46d018a12f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c72b65161ca1487c3b563c24d0c2a60f2400606f9fa3e4442b5d7a697570136"
    sha256 cellar: :any,                 x86_64_linux:  "d22355befd4a985b9e32ab0e2121dee15528114810e764aefe0d96a6446e7c9b"
  end

  depends_on "go" => :build

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
    spawn bin/"sdns", "--config", testpath/"sdns.conf"
    sleep 2
    assert_path_exists testpath/"sdns.conf"
  end
end