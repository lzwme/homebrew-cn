class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.29.tar.gz"
  sha256 "e1c56d5c8114ba0d332f329a63b709f4337b3bb799a2b88ca2d323680b510f49"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ed1ac06dbd38ea1460cebec29071b12c9eafdf217e2d5e98f4c09a148242e11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "601435dabfabb179abe32f7941f1e285dc4dc896b0c524026edb92fcbcb8a445"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1e8f192cf93c983650005649b5b441f5bd5e33efef28a45213c2d39ae8e4598"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0e3412ccd365ae5dd274b02abfa2c00c52e078756aa6be5719856097ff74cd6"
    sha256 cellar: :any_skip_relocation, ventura:       "a68f6f68c987f510442fad7ca9046b9921811309ea1927f29c4b5c0783e718fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f75994f27b419b912d1b6f62420980027088e3f6d8e130d8460770a39236caf6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end