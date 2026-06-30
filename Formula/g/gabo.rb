class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "66798dc2043a48c50e3d61f819cc928588d13faa4b155f8ba4afb6bc736a8e15"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "932a2098bb69d849d648f39f57561eb0a55d1fa1910d64739c701f01c4086e25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "932a2098bb69d849d648f39f57561eb0a55d1fa1910d64739c701f01c4086e25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "932a2098bb69d849d648f39f57561eb0a55d1fa1910d64739c701f01c4086e25"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ab6474883a973613f9d51f26afc7b1f7ed84c6fe4bf5b5f0e5cb733a1e60b31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4b5397e49a2b1718944c39f9e33efff2f1f248696c3178423475bd84e7c7fe3"
    sha256 cellar: :any,                 x86_64_linux:  "6a6b4948f1d35bc501a42cbc1a707f9685787764243a1dea5ee8a6113e30b0c3"
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