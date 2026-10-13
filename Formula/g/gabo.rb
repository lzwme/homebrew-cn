class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "88e8bd706c87d27d2ac1e71f34defbfd9abc985148144458a2ab4f9de0b5bb0d"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7714f675b5d15895ebf5f4f7b0e5c44cb21d955d0079f3f1b50bafd4f69c3cc7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7714f675b5d15895ebf5f4f7b0e5c44cb21d955d0079f3f1b50bafd4f69c3cc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7714f675b5d15895ebf5f4f7b0e5c44cb21d955d0079f3f1b50bafd4f69c3cc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c9a13672b6d308c3a3d4a6056ebd8068f02b864679f029abee14b3f7d1b45785"
    sha256 cellar: :any,                 x86_64_linux:      "28055d25342e199b0e9d6ffa71200b44fbdd10abc5560e41b9f9bc2cb2bbdf96"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src/gabo"
  end

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