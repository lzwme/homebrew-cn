class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.0.5.tar.gz"
  sha256 "1628a218f9b20d5073bd264ba77c8b2c20deb436bc9d014e321fe68ff6435f23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0417727f8e9a2641dc6607121d8017b6fa058fe449c3defefba218e9bbc45779"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0de4e9a7bd4fd01e5cf5826ec196a2640a138b40725444ec7f1daec120c9a319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e373f19e5021529b82712419bb37a79a231a24da8127d69179b434900ed8264"
    sha256 cellar: :any_skip_relocation, sonoma:         "6077ae3496e923261f4282ce1c7977998335bd46b1d3779ff1a0c32b928d49ad"
    sha256 cellar: :any_skip_relocation, ventura:        "3b4602b7fc4ef4da9134127899757ab5609ebe440595fae90623098ff7fca76a"
    sha256 cellar: :any_skip_relocation, monterey:       "3c272f57195e9774da1e3135774ada62c93c1f3a42226b62b68a67e5329a24e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dd96fba5448153879cff50a6a55c67c007d0d08bbbbe7b4735e244861dc633a"
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