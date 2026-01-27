class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "270081eb4e5136d6b2bb57a04b2c350f846ecda6d02abf94df5b9f3afd8912ab"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f3263dde66c16be2a987487b657a5927088863f44b93e7fa52dc65943db5d9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f3263dde66c16be2a987487b657a5927088863f44b93e7fa52dc65943db5d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f3263dde66c16be2a987487b657a5927088863f44b93e7fa52dc65943db5d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "36c33b381840c2d764d515846662204bd367b8abc4d37ab80a4c6084e2023ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f29de8fc77e1ea8c526896b9bf7c3bc486ea2291f3ca932b12f16ad449c0f711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef85f5b1865d9c648dc36e7e25d73dd1df667b9d8d061e695d01d22f7ba4a0c9"
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