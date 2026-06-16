class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "c635e162c55e851f4922f7081b9fe092783b74b74c87785c815ad2b3b2d8f8f3"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "916ce3ef1f1dc2ec3c5f02e0837a5d2956ac07092ceb1f6348a6d105b3a6ef99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "916ce3ef1f1dc2ec3c5f02e0837a5d2956ac07092ceb1f6348a6d105b3a6ef99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "916ce3ef1f1dc2ec3c5f02e0837a5d2956ac07092ceb1f6348a6d105b3a6ef99"
    sha256 cellar: :any_skip_relocation, sonoma:        "0520ce57491f813c5f98c46b93c6a1418fa2273b6444b1563b1dee3c804f20bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bed8e5b5cf92a6959341e66e389f0e3e6ffe03e81ab4471ec2c0bbad39570d7"
    sha256 cellar: :any,                 x86_64_linux:  "1e14b0abe9c037200537eadeb62ad955250c1cdc4a807554415c1452b32ba562"
  end

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gabo --version")

    gabo_test = testpath/"gabo-test"
    gabo_test.mkpath
    (gabo_test/".git").mkpath # Emulate git
    system bin/"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_path_exists gabo_test/".github/workflows/lint-yaml.yaml"
  end
end