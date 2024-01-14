class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.0.4.tar.gz"
  sha256 "a845cd4545574f9a032542ee9034e7b9f2851319b4b765b1ae3266753d2814cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70c48897d0403d548fdb68f865590324932bae31f2f02abe8c1b0508f0616c68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43eae3351eae2885eed7ce8924016f968c2890628433151bb0649518a7097365"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf383f96cc2ecb6f3716544b8e5c44d98fa135a6777b4f760c756f54b757dc1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "33eb3e9804a68c5cbed0b538b02d1e59e10b1d26852df02bdc716171a39071e4"
    sha256 cellar: :any_skip_relocation, ventura:        "df0ddfe7bf5cedba1c59778d49e3226479fab9246d80453e1644e264ca8bdd9e"
    sha256 cellar: :any_skip_relocation, monterey:       "6db76548b97353eac92ce3b8775623a5ffdf38b26c1599b4faa4c498c8c05369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c2d347198a5ba4ff93fdfa03630e6023668f00c61a2285fbdb38bba856e7fb"
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