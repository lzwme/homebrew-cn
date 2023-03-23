class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.5",
      revision: "592d35199f8b215e5710f8d2cf78d9dc2a8003b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "580751d3681dd0509f78c44182d47bdbbfefe72af85064ba0d4b3327cd583603"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccfa90aab9d66a231dc30fb98bb738dccf2278a097265edca08053ad4f50055f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e330e1c142968b8c558bce6363f5bb679bfe25e95450b1ce73d26b0462dd75e1"
    sha256 cellar: :any_skip_relocation, ventura:        "398447642c153132373404fcb85922224478c7ec4f5cb24845d5ee401ca6ad16"
    sha256 cellar: :any_skip_relocation, monterey:       "3e4f1ff4c13c19e9d495f4212eb4e5659cd9e166ff6843697bb5479e3f497195"
    sha256 cellar: :any_skip_relocation, big_sur:        "2aaf162280ff0b533912b4cce605238244c136953eed04f09c4af0d441a29f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75657dd2dca7b249549c8fea26b8ec4947541241276b9c09a0dd72f3b84bbf45"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/saml2aws"
  end

  test do
    assert_match "error building login details: Failed to validate account.: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end