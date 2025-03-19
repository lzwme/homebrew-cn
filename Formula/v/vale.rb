class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.10.0.tar.gz"
  sha256 "2bce5943e0c885dd1bb520922afcce0e985c39d600ae8cf88579aca219c5f1d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f5abab41a09f73c8cf7e1e522f4175f7ea1cbd37fe35a1b519f43076f6fed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfd9d316b22f60a11c07f414c6f29a2105dfbdd95aa40ed923e5d57fef0e7949"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7548362682046e17e54c0354e549e5c0473c9c7d51721b6550797c7ccaa9057d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0391e23f90816ffecb3f4428d09a149ce6691a4668e6f47e603ec5dd2c627e8d"
    sha256 cellar: :any_skip_relocation, ventura:       "5f1eb18749bfcfb0fcc4257e6b09e599295a6547be6be7ad383d3ac603485bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99036e7aa1b0adc70d1575e7b60c803efe902fa51d81e172cbd2ef253df4789c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", ".cmdvale"
  end

  test do
    mkdir_p "stylesdemo"
    (testpath"stylesdemoHeadingStartsWithCapital.yml").write <<~YAML
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    YAML

    (testpath"vale.ini").write <<~INI
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    INI

    (testpath"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}vale --config=#{testpath}vale.ini #{testpath}document.md 2>&1")
    assert_match(✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\., output)
  end
end