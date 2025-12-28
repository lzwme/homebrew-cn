class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "748326a538696f03db810d05b90db631bafa24aaac91b90b961ee74db37a7013"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3289dfe9ae04cfcfa1a7cef62c3ebdcf73795d4dcf4b4713dbe69a989dfa3d9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92846b0f2a051f3f07ee6e018709c8513593486d782c2fa5b69f37c4d1882c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21d7113c9df2465ac926dedbfb65ce7f9e6367053f43c607262309091a31fe4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "aae7235ab306b025af36a174dd4170788624c1a23675ddd9b600d1cfd8a99eec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a57d83d2b37ab70308aea8b13023654af2e841ce7d838a41ac1a9231a100526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8ea83f3c3f81e792adc4bee7650f0c7f91896232d13537fca4a6e4c8c8b32fc"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build CSS
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build-css"

    # Build and install the binary
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cook --version")

    (testpath/"pancakes.cook").write <<~COOK
      Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
      @milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
    COOK
    (testpath/"expected.md").write <<~MARKDOWN
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
    assert_match (testpath/"expected.md").read,
      shell_output("#{bin}/cook recipe read --format markdown pancakes.cook")
  end
end