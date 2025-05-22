class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https:cooklang.org"
  url "https:github.comcooklangcookcliarchiverefstagsv0.12.0.tar.gz"
  sha256 "2e25f242a520854aa94df90e2d0c1e603be7c46e6ab18b5bf8d3db20a7edbdff"
  license "MIT"
  head "https:github.comcooklangcookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6108dd843abad7cbed25c45452e751c9da270da1dfbb93850e66cf78a6c343e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51f5b02644162f19da78aa7d61a71fec1d5f3a510481de72c2e93583a2ef86c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c15cd91ceadd26cf6057c768d5059e9777391541e82a70a5073cf137bddf57cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "77f46245018ff30d37d927e591e8824451e2b74e82d757c4361df959e895f5e1"
    sha256 cellar: :any_skip_relocation, ventura:       "a27da32582901652fdaa120111f6e8b8048c86692949f8493e8e472a6cac5cac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c927b18cc6c175a4ff1bae2b2e3a0fd92ddb0ef07580319e2f39f1d375d5ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4721675ced0f670cc31f84039fcd684e2a7c7c3a6d8d34fc88e038af5262130"
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