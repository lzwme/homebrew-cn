class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://ghfast.top/https://github.com/d2lang/d2/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "9d8b7276c9dd035233008f3a233054ecf5f3c133e89f658f759df6fe3faf6087"
  license "MPL-2.0"
  head "https://github.com/d2lang/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb38fd85461f60aa45abb10e08c8dc87c55ab14eb9f5fbb3526a0b53f842d85e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb38fd85461f60aa45abb10e08c8dc87c55ab14eb9f5fbb3526a0b53f842d85e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb38fd85461f60aa45abb10e08c8dc87c55ab14eb9f5fbb3526a0b53f842d85e"
    sha256 cellar: :any_skip_relocation, sonoma:        "29c5757d4a96b6680b5370054f7b414970c1bdec6b368cac50121f6cedf70a68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62eb05375b09bb37b72f6b511269a845eb5ace7df4885c0c829d14b8da8d3174"
    sha256 cellar: :any,                 x86_64_linux:  "7efca8f1fa46aac1691221caf1123a40e9720bab5daec392b0f79599a6b87cd0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/d2lang/d2/lib/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_path_exists testpath/"test.svg"

    assert_match "dagre is a directed graph layout algorithm implemented natively in Go by Dagro",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end