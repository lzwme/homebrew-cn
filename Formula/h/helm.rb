class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.16.1",
      revision: "5a5449dc42be07001fd5771d56429132984ab3ab"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "90d971f44f4093c9b323a0783ec6a8976210000b558ae83f5c2c3c16f02f73a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "142c1644efb6c7b6d3b81d86241c306077834269898b33737c3d0c251971fdf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3d4dfd246d13211f8ecad8f6965d90181917e485cecd35777b50d71aefda75f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2345ec9dfe444c76faecd980bbcba37e73c49c66476b568b9f1c6761a1799465"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b75d238afa2dc86d2cc7e2a64fcb06792a7721a042f5eca8fe775ce49fd25e8"
    sha256 cellar: :any_skip_relocation, ventura:        "b308bbf6ab8c80e8ee811bb127dccb1e4592e4d9d4acc04bc3a405a0cabd97f8"
    sha256 cellar: :any_skip_relocation, monterey:       "5a3ed563be7363188ccb18914be60af84b08b04bc08eeeac6eeb1d5ebf7c4df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa7f2578d831b15ba3ad6b2ad946be779314ab1cfe9abae3bcb1fe9dac188b29"
  end

  depends_on "go" => :build

  # fix testchart lint errors, upstream pr ref, https:github.comhelmhelmpull13329
  patch do
    url "https:github.comhelmhelmcommitddead08eb8e7e3fbbdbb6d40938dda36905789af.patch?full_index=1"
    sha256 "471c2d7dcbd48d37eaf69e552d53e928e9ba42efccb021d78bbd354599d80811"
  end

  def install
    system "make", "build"
    bin.install "binhelm"

    mkdir "man1" do
      system bin"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin"helm", "completion")
  end

  test do
    system bin"helm", "create", "foo"
    assert File.directory? testpath"foocharts"

    version_output = shell_output("#{bin}helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end