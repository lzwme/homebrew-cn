class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.8.9.tar.gz"
  sha256 "701893d85fb6165bfa4cebfbd796f3594f77d6ca3a2cf305e153a3d22465e154"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d8b90702431f189f1bc71fa612f9d609cdbbf513971d69aeda728804f90532e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d8b90702431f189f1bc71fa612f9d609cdbbf513971d69aeda728804f90532e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d8b90702431f189f1bc71fa612f9d609cdbbf513971d69aeda728804f90532e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1824d9cfa2877caa22550839462b8f680ebf2f792d6465b5815026f583e0069a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "101b7397f13b2fc0648eb6fee25c2706357a6218c260882ff2fbb7c1e79249b2"
    sha256 cellar: :any,                 x86_64_linux:  "a9d965dfc865e16ddbed39f214e18f6a699650762fb38e248a17cf7171a12868"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end