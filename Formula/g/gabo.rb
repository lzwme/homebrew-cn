class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "4e915becb142044d0f4de66ca691bb7b7de8aeb66f010f179e1be2bd5faff133"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3b55bebaa6b3e232c9a54d17376d2f422960774b368528fab4fc76c8dbb35c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3b55bebaa6b3e232c9a54d17376d2f422960774b368528fab4fc76c8dbb35c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3b55bebaa6b3e232c9a54d17376d2f422960774b368528fab4fc76c8dbb35c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04cc56778f238eccbe002e11dc4ccd94367aab6e6a307075604eafb0f3c99676"
    sha256 cellar: :any,                 x86_64_linux:  "6e2912c92984262ac824fccdfefeb50b06b84f5dc60387c43e8f99f56f6e6334"
  end

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args, "./cmd/gabo"
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