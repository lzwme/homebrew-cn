class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "b19aa6ed7f0a1525fb8eca1c576d810ca39acfb5feac1acabd5d5af445ca4bb5"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "647d7df2b2cb8ea19e713a20da7192e5a980de9415920183a1f5a932e960385e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "647d7df2b2cb8ea19e713a20da7192e5a980de9415920183a1f5a932e960385e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "647d7df2b2cb8ea19e713a20da7192e5a980de9415920183a1f5a932e960385e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e46c66aa5d2376edd607e8492b8f152587c952b2136fb6d83098cb881fec4a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf8ba8c763a08713cf58d545f2e4dda0c6a781171306e3b0c1bf9e437d4fe429"
    sha256 cellar: :any,                 x86_64_linux:  "05af1bc4a1dd30b51ef68a4b6a9609d517dafef630ef511a87e2e15b363fe585"
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