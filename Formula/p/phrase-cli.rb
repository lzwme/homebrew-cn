class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghproxy.com/https://github.com/phrase/phrase-cli/archive/refs/tags/2.17.0.tar.gz"
  sha256 "fd044922f55c513960cb3274e27a8dd5d653a5349cb747623b6f9be51e55ee42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b363c00e516132fcd2fccfa1d2608ecd1992dc33a37a20aa98de0faa0d1bfd7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4d9d708b8fbe1d95bfb5e76058492ff7a3534bf5387ebf406d176b666bca34a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cd92d631442dbfde050ad8268aff2aa35d54a7d79317c2c92430ed1b94d64fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "20c0561e07aa2a0a412ca65822638b02031f372bb51a4f5a3999c444d5203843"
    sha256 cellar: :any_skip_relocation, ventura:        "59f680f7b602dd885220bc1e94e74607e6729f54eec5ec3d704c1ac62cfa9f85"
    sha256 cellar: :any_skip_relocation, monterey:       "1c87eb8c8cc0e420f88ccc3d48894e080a74bd37caa4e14d3950c5672e83c9ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfcd53adf2e67710dc943f925f367c3b055a3fa8e77e9d35b8b927834af7b452"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end