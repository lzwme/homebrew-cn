class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://ghproxy.com/https://github.com/pkolaczk/fclones/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "fdd214efe8f26a66e30a5555fed904a8cd8b0a0d6039012654bad96ab60af6e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe53e22fccaf2a703813512051dcfc848923cea3700ce638b11bf6fb6faf6337"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "870827e654304c8026905c441cf9dd1c1e0dd9b9cc328e6bb47d4051eea95345"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66d355cba9a926344f21978dbbd7a33147ffa9815d1be38361e647a3c5b391a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d4263003c117ea0e38de736c8843d0ceb7b1e1e8d6486e9551c3ef14433b781"
    sha256 cellar: :any_skip_relocation, ventura:        "857dae20deeb09838a9405c62a3ce49638ca600c823d1ca18b13de462603019c"
    sha256 cellar: :any_skip_relocation, monterey:       "458971c37bc45d7b8011197025a3c57bd2c6181287f0e7830b0e74a86e47fc6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0af033c0d97fc9a63c757ca860b8ca525250363d7605778c3011d4e78bc41f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "fclones")
  end

  test do
    (testpath/"foo1.txt").write "foo"
    (testpath/"foo2.txt").write "foo"
    (testpath/"foo3.txt").write "foo"
    (testpath/"bar1.txt").write "bar"
    (testpath/"bar2.txt").write "bar"
    output = shell_output("#{bin}/fclones group #{testpath}")
    assert_match "Redundant: 9 B (9 B) in 3 files", output
    assert_match "2c28c7a023ea186855cfa528bb7e70a9", output
    assert_match "e7c4901ca83ec8cb7e41399ff071aa16", output
  end
end