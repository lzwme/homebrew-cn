class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://ghfast.top/https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.10.0.tar.gz"
  sha256 "51a569ff9808c2009a124e4548e3b72af3d67354fe2b04ea92433d6c4320a11e"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31038c2576707cd5a67dfec6bc60a2000845ef5012112dfed4411df62b86f0d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b47bf826728953c54976803ebb0156d95c82f3f890ff635b16f1aec65a59f982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67a4e259c02c58e5ef83080da87c84b3e2a00617f0ed3f0c82658f1be9117a3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f985c1d3feda29ed8026419335778dbcd5100fb758b854c3dd3af297a6defa"
    sha256 cellar: :any,                 arm64_linux:   "1fe1c93384be598533bd423fc6151454798d6cd0a41e77cd37c86b35ce9bcba1"
    sha256 cellar: :any,                 x86_64_linux:  "f3de4442884da1c95f92656bf8de95a68214b46911a45089426c4fd039ffd6c2"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https://github.com/BIRSAx2/mdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin/"mdcat", "--completions")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end