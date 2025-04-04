class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.11.1.tar.gz"
  sha256 "ae0cc34c9ec01f9f6b1f1fcbae71727229d4e3df013a9a6df124b7a9049206e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5d218d2ffd771f9bc191101fd51149b81c92451ff0de6075763cd33dbe63b29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21c32228c1da83f9eb39938bedda5572b4bd27baecf160115a3a56ed8df54eb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36233bae09d93df4f564e39f1a80a04f2e4547060427bfed5f547ebcaf5114a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "421ca8fdc85386aa10559fb7b4b2ef5ea05e120e1051e0ad0a8a8907a4109ff4"
    sha256 cellar: :any_skip_relocation, ventura:       "e14434b43265cf083ce5f0a7c3e03efe6a8f5a354fd17de0f04ff9f655e50cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fea673a9a011c93afd73ceeb5ff2a6b654a0cb389b6e02c9c544b94613550484"
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