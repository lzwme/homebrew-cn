class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://ghproxy.com/https://github.com/kevinburke/go-bindata/archive/v4.0.2.tar.gz"
  sha256 "ac343c4b316b234b8ea354d86eb3c7ded2da4fe8f40d45f60391d289c66cd950"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76617a44d91e752b9bd01f180ae617a0ae71d8109c376162a0a7c7b5a830f135"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76617a44d91e752b9bd01f180ae617a0ae71d8109c376162a0a7c7b5a830f135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76617a44d91e752b9bd01f180ae617a0ae71d8109c376162a0a7c7b5a830f135"
    sha256 cellar: :any_skip_relocation, ventura:        "e5e4f74424a4bc23bdba3c3bd8b74031b8b7c1c3ebcd46cfec1fdca526fbd1b4"
    sha256 cellar: :any_skip_relocation, monterey:       "e5e4f74424a4bc23bdba3c3bd8b74031b8b7c1c3ebcd46cfec1fdca526fbd1b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5e4f74424a4bc23bdba3c3bd8b74031b8b7c1c3ebcd46cfec1fdca526fbd1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc06d08b284da8bc9425c70ed2b7d8463799f0ec962c15904a8bb6a84b9eef18"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./go-bindata"
  end

  test do
    (testpath/"data").write "hello world"
    system bin/"go-bindata", "-o", "data.go", "data"
    assert_predicate testpath/"data.go", :exist?
    assert_match '\xff\xff\x85\x11\x4a', (testpath/"data.go").read
  end
end