class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.8.0.tar.gz"
  sha256 "fe460aaddab7ccffdb0f01981ae44f34e648000dcc83b43f1c3e8e636b231298"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8b54ffb2458237cdaf420c4b12307c0bc580ec04a41a26831c4f178c6ec0f66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0da7bf559a4a3f63422ed9f1629342b14d202e70cf946b0a0160b8a4b0347749"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a869328505e5e724ff386345d39fd27553c28c7d0b1d610c7ce712d73479a2dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aa6517f7f996ba76e72647d19a255f752a91150d17e9f4e0fb0a3c05b49e968"
    sha256 cellar: :any_skip_relocation, ventura:       "c5c77ae6ee3311fc30576eabe7b82500f7cde5ba6b7ccbcaba3a52b5c3d69a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a7f06589c246db7ae38d4927dce91496a8e5bd02f2cdaaa1d22da941507782"
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