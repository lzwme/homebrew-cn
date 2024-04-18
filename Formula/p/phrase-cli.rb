class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.24.0.tar.gz"
  sha256 "bb93db7ba382ab6d499b6c6284d2cf8ceee28c5174e1c24bffa3f79990fa8adf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48e560f045d086f22bf36b5d388399c7ded38a5bf21e725bbbe667f786f06411"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "892ac81d67296e3288e56e755d3ecdbc327a2b8e0c63f2a2e96813caed0e1b4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66259d4b6356eedbc6b5bd14edde14684b8c6eb1cfea5087533fea6e63256073"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4dd962958301592ea3215d637e081d6e755c5ad3f5bc2768ddf9b1f1d48cf51"
    sha256 cellar: :any_skip_relocation, ventura:        "4ceec21064a01101bc2ae0cc2fca4eae8a1686c7bf302c776ef54b1011679043"
    sha256 cellar: :any_skip_relocation, monterey:       "d1e71a7e2bbb27c22c21fadd59a3480386f2f719c23e29d7a1596f6cbda63f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a4c813c94b01721bb11bc5f5faf4a195df72574c26e45021e61305662440a9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comphrasephrase-clicmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}phrase version")
  end
end