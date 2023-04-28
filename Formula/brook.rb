class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://ghproxy.com/https://github.com/txthinking/brook/archive/refs/tags/v20230404.5.1.tar.gz"
  sha256 "c05bf50ce56f1fe0644e38e6d152b62203552f0f16548369e8e857e98efa6403"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed77d95ba2d5d2e912959d8cb353e663e7ec4f54922c6fd220c2b885b443bd80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da0cf222b1879b99f171256d0c3330c86325218784ec1fed9decc2a4fe12c62b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "121ee61b26e717f3f7bf00337c22c4933013640324f39731092bdcae9796af34"
    sha256 cellar: :any_skip_relocation, ventura:        "920272182c26f44dec29a9377d7ba70b44dc8087ff4548e22f9ca04560405e77"
    sha256 cellar: :any_skip_relocation, monterey:       "c09dd23a922624562591a2ac8d3db3e1b441c28c53a63a8f49c75f894f361729"
    sha256 cellar: :any_skip_relocation, big_sur:        "2374d50e4ea7ec458c2b7c66c3564ff7568ab817b47df9c778f664d13dae50c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e84f673ec2f9cda9e23f1c44993c807966ab55ae41a79766cd4b40558556c0b4"
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