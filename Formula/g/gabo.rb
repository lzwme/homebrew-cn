class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "e2716f7abdf0a6e4b1d7b43e2cfe49891609e3876907c5f6fdd8ff9b223577c9"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e863c52b27292a66b57497df679888d5bbadb3ebc3b112e780408a8ef0e46419"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e863c52b27292a66b57497df679888d5bbadb3ebc3b112e780408a8ef0e46419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e863c52b27292a66b57497df679888d5bbadb3ebc3b112e780408a8ef0e46419"
    sha256 cellar: :any_skip_relocation, sonoma:        "012f0d79d826c0f6f4bca9925b824d15ed3f3db146b2af3a1e4d001096e0a736"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d87b3d0cc85231d27c1dc6af5066d212c21f6cd02f78067d707f549193a331aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63904ba3a68f8cbc2e0e49669530e33705a4f67ce659f773012096386a6ec57b"
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