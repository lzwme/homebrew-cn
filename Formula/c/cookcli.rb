class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https:cooklang.org"
  url "https:github.comcooklangcookcliarchiverefstagsv0.12.1.tar.gz"
  sha256 "fb271f7d52f62a3be3f1feece68f8ec1fac65721c24a4def0586dc1c834148d4"
  license "MIT"
  head "https:github.comcooklangcookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61f01f09c04d9981694142e9c7041cd6dc8f64f206ce68bfae444f1d24426ec3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f46d49616202e6219c80fe88a0eea1ba8b00e2195f7198a54845ea8fd030cc4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63be6766ed9189c65d1a20b79efd998a7bfa13edc61d57f5ca8d21852a65264a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b88216e4102ef6eecb8fd16908b00c034c5fc51eae1dac4d80b7dc0c1c2334fd"
    sha256 cellar: :any_skip_relocation, ventura:       "a94a7738afc2ceb2f50462d9681ed1c7f0964c5fb4fc399c8f1be1fe095db73c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "849335be5b14c590b959edfaadbe7ecce43b181d801aebfdf5145ce4b35c039a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d62d6abacc43e2a000e65a7b2803e11fba212fcca4432febc9658f8dcc57770b"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cook --version")

    (testpath"pancakes.cook").write <<~COOK
      Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
      @milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
    COOK
    (testpath"expected.md").write <<~MARKDOWN
      ## Ingredients

      - *3* eggs
      - *125 g* plain flour
      - *250 ml* milk
      - *1 pinch* sea salt

      ## Cookware

      - blender

      ## Steps

      1. Crack the eggs into a blender, then add the plain flour, milk and sea salt,
      and blitz until smooth.
    MARKDOWN
    assert_match (testpath"expected.md").read,
      shell_output("#{bin}cook recipe read --format markdown pancakes.cook")
  end
end