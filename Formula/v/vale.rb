class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.0.0.tar.gz"
  sha256 "64dce5b3c95e8390aa0b130a7da2637ab22a1b4afd16c411fba79969b1c9c968"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d58668ac5b3462b886cd8f7768c00cb7699930869331ecf19d391993f39078f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d241eb7ce54d617f3d8306f4f75a0926cf0fdb0119e1c5c7780df33707a1532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "548cb46712df5501d503050e3f93e9c69c0a3b016e86584d6ba4ca661f74d990"
    sha256 cellar: :any_skip_relocation, sonoma:         "46a1b6211d77f3e7893a48fc9b5d6e16a4817b6c89fb4f9636d24e03bf09c4c7"
    sha256 cellar: :any_skip_relocation, ventura:        "38692eda10dcbd0fd8935bf89d0cad2014cc0a91be54ba10d6896cb1d376f2f8"
    sha256 cellar: :any_skip_relocation, monterey:       "aecccafe584c5d36b1e9beaa517cdb10608969d069042e47c6bbe34c70dacdef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "956ed9b6b5bf0249197ad1d0e4410c4e9ff376ef537f163637512657067a9f60"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", ".cmdvale"
  end

  test do
    mkdir_p "stylesdemo"
    (testpath"stylesdemoHeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

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