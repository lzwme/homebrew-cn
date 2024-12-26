class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.9.2.tar.gz"
  sha256 "cfea2110f3c7903bdcfa616d39321e0867e2a2bb766f881024b9de169d5d1850"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9870c45581dc943af9ed2f86fc5fbfa17cdcc933e9062a6c41d5ba321fb52c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95f6cec7899e68512390b26d72310e0225d13f66841fd2cc0197237f49914914"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f4d998ecafc70243040593e23e88c13379b7a54ec68faeed272c418beabd16e"
    sha256 cellar: :any_skip_relocation, sonoma:        "947384c83aec8629c296ff544732cceafa674e10d37d3b3cd8a34a927ff68cd7"
    sha256 cellar: :any_skip_relocation, ventura:       "4e7b9a121f84c919ec98b80e5a9a356a3b8f197248bf1a2d9b40697b01a89c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdb0a35496c0bbab5a0d03a2a1596912b67c5c48b8a64d85c958274c3c965671"
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