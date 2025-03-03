class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.9.6.tar.gz"
  sha256 "7bc4658aea1f80b5c43e43d77d5f8b42a2ae3f9b213ec0cb30fbce35001fa635"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "665d945b9998fa62543790304f43d2cd80bbd47489cab04e31c27b87abd86b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f60e87cf1b3f26a099f6e33813482c7b8971c08b1704c97994c9d4d7a8a7dc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1483f292752ca8dedc1214fa3ddc2facbc41aad9eb5c44d4ad5ee7affa351e8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2528f4b1496643cb7a79676a4b1997764115544a3c72996a3ddf2e1c78f88a72"
    sha256 cellar: :any_skip_relocation, ventura:       "1075a1be95ec7a6c395c7f0f73a1e578a32d96e07bfcf9d12108685ce6197db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6512b628adc99c533bdab7db22117f84938a264e2ebd54b64e8abd3ccd8da33"
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