class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "ef52f4ba54e645159604ed5cfec145889e77a605a9cd270db6b32163a8cb50f4"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0d6a3523878e15683d745d577310bd81e5c353b278912da38c8e85fb5e34138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d6a3523878e15683d745d577310bd81e5c353b278912da38c8e85fb5e34138"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0d6a3523878e15683d745d577310bd81e5c353b278912da38c8e85fb5e34138"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a52fa3e8f5f76c7d7b3c148af4ad22e88d0f1afe18f50d6b4ff63bbcde8299d"
    sha256 cellar: :any_skip_relocation, ventura:       "7a52fa3e8f5f76c7d7b3c148af4ad22e88d0f1afe18f50d6b4ff63bbcde8299d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76e562875f209c44470c2087f7b9647650ad9aa71a1979c64d7d6ba012f898e"
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