class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://ghproxy.com/https://github.com/txthinking/brook/archive/refs/tags/v20230601.tar.gz"
  sha256 "0a80773ecad13cf10ae4de9e33ac1cec751f269d09d6e8991dc8e5dd01a1b101"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52253e16780abee25d90520ba03f3d38b1654b0ca2eda5c905e53d62a4e1db19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52253e16780abee25d90520ba03f3d38b1654b0ca2eda5c905e53d62a4e1db19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52253e16780abee25d90520ba03f3d38b1654b0ca2eda5c905e53d62a4e1db19"
    sha256 cellar: :any_skip_relocation, ventura:        "0abfdbf2450fc2d775bcb8428402331cab37bccca4c14bcf39f342b9b51609f5"
    sha256 cellar: :any_skip_relocation, monterey:       "0abfdbf2450fc2d775bcb8428402331cab37bccca4c14bcf39f342b9b51609f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0abfdbf2450fc2d775bcb8428402331cab37bccca4c14bcf39f342b9b51609f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a795ef627b04c894a20cdcb3249eb685f083935357a0d7361a8e221554dd6f72"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    # We expect something like "brook://server?password=hello&server=1.2.3.4%3A56789"
    uri = URI(output)
    assert_equal "brook", uri.scheme
    assert_equal "server", uri.host

    query = URI.decode_www_form(uri.query).to_h
    assert_equal "1.2.3.4:56789", query["server"]
    assert_equal "hello", query["password"]
  end
end