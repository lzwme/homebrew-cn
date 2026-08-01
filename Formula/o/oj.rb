class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://ghfast.top/https://github.com/ohler55/ojg/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "6b0c0e9e37fce6a9a499842a0c886e8c2b67c32ffdceb0a491973c88b7db5d90"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76554bbeff0aba4b6c5535a0ecd4b44d4bbaed3375dfd985c2b3cf0168caa0ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76554bbeff0aba4b6c5535a0ecd4b44d4bbaed3375dfd985c2b3cf0168caa0ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76554bbeff0aba4b6c5535a0ecd4b44d4bbaed3375dfd985c2b3cf0168caa0ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "199013122d5c7daf94276a38e451c8028a5dd1338856d0ae8918ab43430371bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac7f4707b666198df7e19949ccbc6d0dc09ed666e146542126c44cb7c7cb7b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59e079863919e0ba60d6eefafb9bad06bd3fb9f36d9de6cb073a7711e78bee57"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end