class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https:github.comstepchowfuntagref"
  url "https:github.comstepchowfuntagrefarchiverefstagsv1.9.0.tar.gz"
  sha256 "51775ee3b1f67fff71bf8db7f2fb35c6123df10f36220185785071757bdaf3eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c3be4fe99d8b8a432a21a247dfb901a5dd2ee4ac28a4385db91d47946096710"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e4ff09c5e0cb8d96972b41d48e63997be15ec2cb8b204b79e6fde6402d12467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68e1e606275b0717a510edeb2bea5bb79a8bdedec83ad0a11b761a0e953c0ede"
    sha256 cellar: :any_skip_relocation, sonoma:         "9975e4bba6ebfff0fe5db732a6c63862515d12fefec5b1d715a54846d2f356f7"
    sha256 cellar: :any_skip_relocation, ventura:        "08287f48149761447d4fdac5b8cb67c1168925b1e0ecd29b755351ab5edb2a93"
    sha256 cellar: :any_skip_relocation, monterey:       "5bde4301386bf3382e21fbfccc95affb3a9aa30452b9000056f51a776124f6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64d2ad4cf237a347602bd6091094d7017f228d3c17892f5afe3a08b9b55e7c88"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"file-1.txt").write <<~EOS
      Here's a reference to the tag below: [ref:foo]
      Here's a reference to a tag in another file: [ref:bar]
      Here's a tag: [tag:foo]
    EOS

    (testpath"file-2.txt").write <<~EOS
      Here's a tag: [tag:bar]
    EOS

    ENV["NO_COLOR"] = "true"
    output = shell_output("#{bin}tagref 2>&1")
    assert_match(
      "2 tags, 2 tag references, 0 file references, and 0 directory references",
      output,
      "Tagref did not find all the tags.",
    )

    (testpath"file-3.txt").write <<~EOS
      Here's a reference to a non-existent tag: [ref:baz]
    EOS

    output = shell_output("#{bin}tagref 2>&1", 1)
    assert_match(
      "No tag found for [ref:baz] @ .file-3.txt:1.",
      output,
      "Tagref did not complain about a missing tag.",
    )
  end
end