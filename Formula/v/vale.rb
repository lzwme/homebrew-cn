class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.9.1.tar.gz"
  sha256 "77cc65eab69827f3a3b372b4edd1e1d11079e087768038441cc26976ebe9b48d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f04773088e5c1e627becd0737b44c680154fa7c93e96e74677c80baa03338e6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6207dd2dd37e6ac75fb7af17c314b9282039aaaa8e2ad0884631c76a0481beb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01cfd96e03307b1d008cea1e3ffdcec751c31adb6ced4bf55da5ae2034869418"
    sha256 cellar: :any_skip_relocation, sonoma:        "272a5d96969128adc31d8978c775284035e216f6c7ffd6392484abbdf0fcbaa9"
    sha256 cellar: :any_skip_relocation, ventura:       "419c1d8f9cf03bcc761dc2c4d60640fd0d7d9ede398bd252efd81eff0ddf6fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee1a1eedea9a6e7b9e07a7996989ec0e96053c0d656a2eea36f6ca8c933966b1"
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