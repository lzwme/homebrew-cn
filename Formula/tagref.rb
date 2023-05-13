class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://ghproxy.com/https://github.com/stepchowfun/tagref/archive/v1.8.1.tar.gz"
  sha256 "bd9fcb643398a5c4f6f6bbf82f4a3e1d7b043e4daddac267318bca6a73a8da03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e37ef4af60228542f35c55b866eb62b1f9ed45937bbdfa4ef811bff66fcedfe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "431d76668fe78b6d3ee9ccaa735049df3e3ed8112bb2a576ef3995bcbbf8e24a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c97a44d13e93ad9262072f6b20e3bcae7e3b850ecc9d907049a5aa58ba85156"
    sha256 cellar: :any_skip_relocation, ventura:        "83d5bbf58553fef985822e9f24132e17b6e04bd0b30773667ff9a3c6a85660a0"
    sha256 cellar: :any_skip_relocation, monterey:       "f26989bb0222347bed802bb2b7b4a3153cb074c4e0661aaa67ef544f6e83ce22"
    sha256 cellar: :any_skip_relocation, big_sur:        "0554d7e3b695249a714eb45237c78fb1cd672c1cb33f4244753e21c964c86501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d30773c5f2b6726c02de3574d6fd2e0e4e3e7cbf3c70b92893462b9ca26474e"
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