class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https:arrow.apache.orgdatafusion"
  url "https:github.comapachearrow-datafusionarchiverefstags36.0.0.tar.gz"
  sha256 "b14e9fc36b7f289493066e0bfa10d399d1d58be093453034912f0324c5947593"
  license "Apache-2.0"
  head "https:github.comapachearrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40d39e7ff75762623b178c8e7247d0f43ace365af2254fa4d432ab8c59bc85e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e644135850b125fd0f03e4febe61034b068a67879b84ced3977d46a3e2a0bfe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62903e9996796733ce39779dd06bf51afba41357bd676c6f7335ead8c5e683d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b212f0ae2e6e4229c6043f090c68c0129aecba6dc34d664272bec9c99305bc05"
    sha256 cellar: :any_skip_relocation, ventura:        "f725cd0b3c3ddf003400c8e29ed6cd805eb7e5295e3d9ccf7055d630c0999932"
    sha256 cellar: :any_skip_relocation, monterey:       "b782499ad3748ce643eed71b1c41f8154b38974b5237b1a89724e643e0ef7dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34784b5ffc08f5e2a512d81d9962a743b93f278addbcc1d5c63190991e887ce2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end