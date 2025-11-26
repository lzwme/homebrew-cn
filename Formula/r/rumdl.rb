class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.182.tar.gz"
  sha256 "26af124ac63c607de3a633198260b014233514b9918ea8c6f54b5fb2914d28be"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cb4613362945d986bf3a5522c178c41ec138011f6fa6cae232f132d3dfb51b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "304338b08e8cf07ab7eb0feeb56b9d035513bf47d3448d02310946c0ad81270c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d54a65526e1dd421b8e687d9de7b6b26fa7d9617b1b8497a86512a6f843c4721"
    sha256 cellar: :any_skip_relocation, sonoma:        "53d91ab2ff7539ad16e39065642b6d9d442b24e74d3a6b259475c0e139eb0a1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b5facdf78bbe8f1e661635ddda99ed690c6150b162788af79cd806fa1ad6fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5980ca5cefe3faabfc96011338e3389ffe289dd6386c5b46484eca4c23e0d7ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end