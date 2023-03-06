class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://ghproxy.com/https://github.com/terrastruct/d2/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "10bba8b81bc6cf4dd7bdb3959dfa105d5111feb45a184be7b5860c826838d319"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9dbc15b8e400a1ae94561668193f9eede7a72be92f25a760d510ac50ad8f8e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9dbc15b8e400a1ae94561668193f9eede7a72be92f25a760d510ac50ad8f8e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9dbc15b8e400a1ae94561668193f9eede7a72be92f25a760d510ac50ad8f8e6"
    sha256 cellar: :any_skip_relocation, ventura:        "6c66e1c17477940959e7bfdb20f2bec8c3a3d96fa0d168f3add3d74967cdc5c7"
    sha256 cellar: :any_skip_relocation, monterey:       "6c66e1c17477940959e7bfdb20f2bec8c3a3d96fa0d168f3add3d74967cdc5c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c66e1c17477940959e7bfdb20f2bec8c3a3d96fa0d168f3add3d74967cdc5c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9719d22b67565d1528ff02c03c96bb7121813a5a0f593c7318548aa02ec05f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end