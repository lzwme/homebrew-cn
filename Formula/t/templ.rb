class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https:templ.guide"
  url "https:github.coma-htemplarchiverefstagsv0.2.793.tar.gz"
  sha256 "be924c8b359748b0109c18831e1105618f6174a0f40645d5b82a91e7a9a8fffc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bf57634a112496ca1987739aec06c616a8bf4361ca2d6b1143737eebc36e969"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bf57634a112496ca1987739aec06c616a8bf4361ca2d6b1143737eebc36e969"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bf57634a112496ca1987739aec06c616a8bf4361ca2d6b1143737eebc36e969"
    sha256 cellar: :any_skip_relocation, sonoma:        "aefac0f53a8554d8b4865645445625113fdc5b9bab1f088fca7a3a77e3ae071c"
    sha256 cellar: :any_skip_relocation, ventura:       "aefac0f53a8554d8b4865645445625113fdc5b9bab1f088fca7a3a77e3ae071c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f76fc66c6690bb07d598d4701db7c375b1f774c5d9047e7d2d2acc7837b31d66"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdtempl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}templ version")

    (testpath"test.templ").write <<~TEMPL
      package main

      templ Test() {
        <p class="testing">Hello, World<p>
      }
    TEMPL

    output = shell_output("#{bin}templ generate -stdout -f #{testpath}test.templ")
    assert_match "func Test() templ.Component {", output
  end
end