class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https:k6.io"
  url "https:github.comgrafanaxk6archiverefstagsv0.16.0.tar.gz"
  sha256 "b6937b4ce7a9420919e700d071943b698d1e5b1b1a57fa894f17076d21264da1"
  license "Apache-2.0"
  head "https:github.comgrafanaxk6.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ac1b31d605bbcf44144ccbb3242fc806aec5e398de93b9aae2ca8d2ffe20953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ac1b31d605bbcf44144ccbb3242fc806aec5e398de93b9aae2ca8d2ffe20953"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ac1b31d605bbcf44144ccbb3242fc806aec5e398de93b9aae2ca8d2ffe20953"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cabdb0e1be7dbcd3521578cc007fe91e85f76bdc8ae2d3acec922ecefc0452d"
    sha256 cellar: :any_skip_relocation, ventura:       "2cabdb0e1be7dbcd3521578cc007fe91e85f76bdc8ae2d3acec922ecefc0452d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a509163560c885fa8c6fc13e1d25651ff2b482388005ed1969124aa782bb3565"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdxk6"
  end

  test do
    str_build = shell_output("#{bin}xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end