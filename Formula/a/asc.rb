class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.31.3.tar.gz"
  sha256 "14d6467df75c27593dbe1a76b7c1700c6f2e613ae93781783786be8420254b97"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c70ea9d6a0d94040c0f3ab0b1b8579f560d7dd2864911e04f97a32cce9b63bde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6520e2412d135528c1773c7d31ea80c3ff7f8cec256afa766463a58f1c86e07b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f95bcf85dee3116b06323923c9db26772da3bb06261394b59729e48b189c57f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8133662c89216ec3cce0350521a45cafb9f9c5cb10470e80ec06d3a9d2b28e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaa28409b1eecd73059daf0fe541dde9684244a014b9737f920f9686d163d62d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "980ed69e5a65912c9516dc81bea1d0ad14be31c71083c9e621c9f6a57db6dab3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end