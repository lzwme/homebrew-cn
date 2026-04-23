class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.3.1.tgz"
  sha256 "381fd3513983bd9f6b2be05218a70d38bbc33598c9816f2dd5ac8e8f13a20eb0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b658eeaa4998364f3b9a2bf68edcd2a89549d2021ac7806e6a3383075579c218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b658eeaa4998364f3b9a2bf68edcd2a89549d2021ac7806e6a3383075579c218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b658eeaa4998364f3b9a2bf68edcd2a89549d2021ac7806e6a3383075579c218"
    sha256 cellar: :any_skip_relocation, sonoma:        "c577aaf3f8bbe1628495baf0c421e02bbc19d462fa0df8048d833a5ed7d3e459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c577aaf3f8bbe1628495baf0c421e02bbc19d462fa0df8048d833a5ed7d3e459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c577aaf3f8bbe1628495baf0c421e02bbc19d462fa0df8048d833a5ed7d3e459"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec/changes"
    assert_path_exists testpath/"openspec/specs"
  end
end