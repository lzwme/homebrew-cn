class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.37.0.tar.gz"
  sha256 "d7fb8176b866188d45bd807130ef19d4ed3872d083cdf61b7ffcc0414460a02d"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfbf38afc5d9630bbb3ff214817a7a65396dabeaacd647df572b77decb408812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a851d49164f202b521f67d939645e4255a3a0e9e246a851108228b2df4cdf236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9715a4d4d9204553a88e5aa9af7a198aea74e457888b04b8d30eb9495264fe8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "442a82e03693ef04024852b5fc68a1f417778bfeb9abde2bf7f2afc278c3a623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "483dc6baaadfc38b2a11ce835a86cd698fd882788cd31ca0241216ac08273be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a46981705cd25d319a35c411e237ff11bc6911a30bb36f9a3890a8fbbece7d3e"
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