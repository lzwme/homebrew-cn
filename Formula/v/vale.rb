class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.0.6.tar.gz"
  sha256 "03067e856805dd0e07006d1bbf8f56f8ce60cc5dd693fc68103855729f50f0d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98a4c986c5f3343d4ac377bae83dc8e7c1cf86cac4309ee2ba41dfc596bf3493"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04c2e3919ed420123b88d84bbe12de160d49cdb22aecb96b13bd454d4331dbc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "969245c65b0f26ce74b0f2786645538316045f0d360c178b766e2e2237dcbe72"
    sha256 cellar: :any_skip_relocation, sonoma:         "691f0bbc0e91e69ae0060afca71fa4b4ed0ca5dffb48d0d38e118c0e3c408340"
    sha256 cellar: :any_skip_relocation, ventura:        "c2c1c75d60b42d4033f9593c026da9028faeaa29fe9477c20ec16c77a1d89f0c"
    sha256 cellar: :any_skip_relocation, monterey:       "db04e09c0e240cecdca8e6c9bf15baa7bdb16a0f3bc21d405ab7cd922604eb13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d490c51040e202db05954ab5da40b1b6670e05d23863cbd5a3d8bc052e8c2a3"
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