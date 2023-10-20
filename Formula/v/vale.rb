class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/v2.29.6.tar.gz"
  sha256 "6ac15dd6defed7618d61f1bbbc79d20358f919ade8f60037ea5da775e4b554d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05e3a10167a5eb5a006ee84b9475667ecffb905c91b96c8e2f14d1c8155c33f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c76354047dbab61dd6eabd57a7696fa1e018c734195f2a3162e8d7391e972ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47b93b5bdfd92c399e94b0410504316fdef6a52eb63b8a2a2f02a5d78e04c47b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e62675ee738a215135d0b89d10ce6cd55d0f2ca09ec38e4a5655c70470a5417b"
    sha256 cellar: :any_skip_relocation, ventura:        "6e50c718f460a0a77f6a62faebc94e951a4f45ac7e8701f0e26dd5508b3d79a6"
    sha256 cellar: :any_skip_relocation, monterey:       "80f5018f609ee0e62f47b0cda14dfdc17c63bce9f3acc71d1415e1c0f634e575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b94563d083ab001aeac3d6753b4cf3f5a2ae911c71794414794d1887b9726424"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end