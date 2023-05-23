class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://ghproxy.com/https://github.com/stepchowfun/tagref/archive/v1.8.2.tar.gz"
  sha256 "a0a389f8e19c9f9d16b35d86e63df834ac380cea78f93a81fb288263ded7e6d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "775ff3761e46333cde443c0aad5c70e07a5d8729092565f7f22a5459bbd92bd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c80bd99a87e7b63425d659369c64586119dec478f77400565fd5c40f0046a38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad05aec12e0d79cfecb963934286da8cbbda8918c790e33fa8e75d140c9431e2"
    sha256 cellar: :any_skip_relocation, ventura:        "fc23d8e3e080d04d08ffd9a9ac2ffc9ff6aafb9d5a7e93e43b0fe0832821770a"
    sha256 cellar: :any_skip_relocation, monterey:       "e3fab210f6d5c5ce394f68f1e0d04e5f54ceec37916eb7a327b8dc545a5c4e7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae7cf66ed619de4c0de4fb541650c54f69eaa2822670a83aab07c8b414c3c2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3bc3bc0f07b3ae14d5153f5bb282b3f643d92f27610d4f21f74d0051bc385cb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file-1.txt").write <<~EOS
      Here's a reference to the tag below: [ref:foo]
      Here's a reference to a tag in another file: [ref:bar]
      Here's a tag: [tag:foo]
    EOS

    (testpath/"file-2.txt").write <<~EOS
      Here's a tag: [tag:bar]
    EOS

    ENV["NO_COLOR"] = "true"
    output = shell_output("#{bin}/tagref 2>&1")
    assert_match(
      /2 tags and 2 references validated in \d+ files\./,
      output,
      "Tagref did not find all the tags.",
    )

    (testpath/"file-3.txt").write <<~EOS
      Here's a reference to a non-existent tag: [ref:baz]
    EOS

    output = shell_output("#{bin}/tagref 2>&1", 1)
    assert_match(
      "No tag found for [ref:baz] @ ./file-3.txt:1.",
      output,
      "Tagref did not complain about a missing tag.",
    )
  end
end