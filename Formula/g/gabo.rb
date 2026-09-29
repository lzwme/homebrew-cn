class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "d0e3b4bc4011aa8cb4b3371bbb6b887ca652edbbfc04ed7f4837809c3339e652"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82a3b640b84fced3ebb8afd843bc836736a56041af6d02c68864a58a7dd390b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82a3b640b84fced3ebb8afd843bc836736a56041af6d02c68864a58a7dd390b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82a3b640b84fced3ebb8afd843bc836736a56041af6d02c68864a58a7dd390b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "02fe1ab61bc61b826383ff1afc68ae8517b460455ede84eafcd30d0936d8a49a"
    sha256 cellar: :any,                 x86_64_linux:      "69ce7a81cb33f49869103c0a14e2d314510d98c410da7ee43adc648c45fb1233"
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