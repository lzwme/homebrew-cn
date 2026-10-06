class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "35d36397b20d47c3cf05428f82e51ed107aefde1af06b191e6fdd1411510bcf5"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03cabfe15d90df7cbe980e1591c83ba91054574e1bd657e6978b6c7c6d494cc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03cabfe15d90df7cbe980e1591c83ba91054574e1bd657e6978b6c7c6d494cc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03cabfe15d90df7cbe980e1591c83ba91054574e1bd657e6978b6c7c6d494cc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f8811c142ace79c7356d768d9cb4bcb57d7e7a0f0bcfedd847394a5979d77eb8"
    sha256 cellar: :any,                 x86_64_linux:      "db04e7481ce58671c5250a21a4e5a7be2c66430bc3cc40388c3bc140292d018f"
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