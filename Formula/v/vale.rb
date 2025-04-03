class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.11.0.tar.gz"
  sha256 "d64bf09b4c90f0d6a62807076a59ccd7aa6db6860eae57bf682bec57c9e82c01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b72e58c5691ac668e111345f4d656b0fbf00cc2a0f965976ca90bfc55fb580a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e1db9a73abac8d7d2533701b3a1465774021a9500308638e3d24b96ad3ed3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b38fe6967a46587084b3b7bae774581a00c0f997cbbe2cdb6329ef73503b8f23"
    sha256 cellar: :any_skip_relocation, sonoma:        "070ac618618a1dd4e2dd4f1502a10d107492d389e67c8081ae9871f83db1261f"
    sha256 cellar: :any_skip_relocation, ventura:       "c7d7acc0d801b853b36c504e909ff7567c990616e5c694f5f10cc174c230ca6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5087ef972aed9dbfbe6e765dabb91ce1d372c61c74ee1e145a433ec475f65a0d"
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