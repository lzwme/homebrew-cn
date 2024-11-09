class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.9.0.tar.gz"
  sha256 "393ddfef73206cab948709898fe6891b347568f7121d2ff517280128952a1f49"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24c395a132a0959876f65946b9febc0a83fdcdc0c032788795da1ec4934a151d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc72326e7e9ce9ea8df23e3c0cc66dedebdd267c4a57f55a6c0bef4c459adabd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd9a77b2583fdb7bc6256c17a8e7624971ac2206fffbbc5108386ff5bec546f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eea89d3ebc17cd616074366f60ad6f69e6d1ad9e06ecda3f6a789f948f3781a2"
    sha256 cellar: :any_skip_relocation, ventura:       "d1aeeef464edd22a92d17901d58a0b7b88ea41e76069d1749b0fdb1be8beda8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d537c77dab9e79a44226ab51bc6e13d6813b0ff2d1fa3907114dd7d9829b1dd"
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

    (testpath"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}vale --config=#{testpath}vale.ini #{testpath}document.md 2>&1")
    assert_match(✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\., output)
  end
end