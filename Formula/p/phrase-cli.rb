class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.61.0.tar.gz"
  sha256 "969e06fbf152a875109f1beb743a2c14806c1d06e366f726a83981fe1a3f1153"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03dec7fd092540d4cef9cf166e0683f9ccc66b4f9dcd5a3d8b648b7dd2f0a5cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03dec7fd092540d4cef9cf166e0683f9ccc66b4f9dcd5a3d8b648b7dd2f0a5cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03dec7fd092540d4cef9cf166e0683f9ccc66b4f9dcd5a3d8b648b7dd2f0a5cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d63e97eacc9523fd220d5ced9365789abc6729e1d44dd345fd61c7ed6d3ea6f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42900f137203f81dcb40a8b97cbbd103a001753dbab1543e3175b04db302535a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d1773a3dd63c60cf355cff4a3541c7fc0e193da0781c62ae01ae802b1e7303b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end