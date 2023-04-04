class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://ghproxy.com/https://github.com/stepchowfun/tagref/archive/v1.6.1.tar.gz"
  sha256 "e9ee7d99396d20098c8bdae507397a732b7ae31e41218cc01a9cd202e817b734"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90f462b53003e816b9fcc90278a1548e7c0b66e72125ff530c23ba3751c6160d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33680042f2f440c576d13402512fa5ebcb8aa1ea417084b03279c8e7bf2c6e00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc0236bb7741b1adfb5681ca9b0c6acd49bd69a9f2a38de266dd79f2c265e561"
    sha256 cellar: :any_skip_relocation, ventura:        "36d89d2c5a78f98b04ede4130f1f3595e3915184f7ed04d0a849adaa6e59010e"
    sha256 cellar: :any_skip_relocation, monterey:       "d9cc9e26bafbbbb884fb9d7ee9ccb790de36b2f0d045c059ab5076af51ea58dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7795eb222c95b50ca19e12520eac702af90059ce537f96a4f6cb74fd9ccbfbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6cc8bda4e1499fecb8855de187f32895a7f5c05236dbfddbda8e7c37fb52f3"
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