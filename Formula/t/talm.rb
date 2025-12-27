class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "2111b11ccd00ac7fc9d90fcd74711b7494e6b1bda18f07042ede77a346c7ca02"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79a6dc86d6d133e77634bdaf11370558c0370346b720ebaa7bb932e6db630dcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bc0bef995966e861241ae71e73af0e571bbcc905fc1ebcfe1fac19aab4796f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "619087a8025e93afb15b9dcce6d8041c326c0769f04922ee06916336de3f4810"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d8a32db8bd981d495b130c29081d497dfd13336a3eb0def2def3fe34aeb19ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4288ec6331388a77b02dd37894d478728d9366fbb6afece1423a9533546965f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee9095b0cda453bce33ead0c2ba4bcb81bf7510be644a4b2da9d3077c9a9badb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end