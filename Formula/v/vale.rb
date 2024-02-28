class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.2.0.tar.gz"
  sha256 "8fd17d0f66c5d2113f4f789c32775df8bcca60601e650b2432457d5a427147ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "949021edf1b4a71651af1f9d0991d58d29113e660c7e07bf70ed25d5b90d39a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b52771ddabba8bd800a148d4179fd90edf4c11c6a40e5a40b90f74083780b8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "142598e1d0b8641d9c94365fcf02e8a1607c0aead3d51b5a7d508605d8e48954"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce79b7cd4ad7337ab6b912a758da8358002a1ee9a59f94f3b84270c8ab972cdb"
    sha256 cellar: :any_skip_relocation, ventura:        "3850cc2510465888215c4b04d9a3f602168c4290bfdaaadd772fe34f4e99edcf"
    sha256 cellar: :any_skip_relocation, monterey:       "de7422f198397be996dc906edb64a120c06cc2724a4e682e8ac6fbafed1377dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd0f5d1946a444e7cff0cb4d4815e6f7c7634d395fe2ff628477a4231f41e282"
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