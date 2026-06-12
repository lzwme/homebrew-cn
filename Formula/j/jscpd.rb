class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.7.tar.gz"
  sha256 "cfbf2d14029855c73ec52a3cef76f5cd0a7a707b0fff6ae67e7e35281808cb97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae120e07e1fd65bc7100f85afb4e34ad3860625adba9da11bc6293f763f29549"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6613e03a1d861713655220e04776820927d442123847fe97ae7c5de9991cdb7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9423e401cad5f259ab9ce1bad145a7e028f7c9887fde6c408ea1dd7b91853bd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d248126edb9767acf3199fcff50d6f8a33ac3a1fa53fa564fcea98107716a7db"
    sha256 cellar: :any,                 arm64_linux:   "ba4b2ace628f8e49f9df23dfeccc7c944750f70a101bae281e7feaa0994651cc"
    sha256 cellar: :any,                 x86_64_linux:  "8ce6d316b2d14ac23b8545b4ef734c6eec4b8b66979a91727ef3ff9ace5628b1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cpd")
  end

  test do
    test_file = testpath/"test.js"
    test_file2 = testpath/"test2.js"
    test_file.write <<~JAVASCRIPT
      console.log("Hello, world!");
    JAVASCRIPT
    test_file2.write <<~JAVASCRIPT
      console.log("Hello, brewtest!");
    JAVASCRIPT

    output = shell_output("#{bin}/jscpd --min-lines 1 #{testpath}/*.js 2>&1")
    assert_match "Found 0 clones", output

    assert_match version.to_s, shell_output("#{bin}/jscpd --version")
  end
end