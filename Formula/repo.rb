class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.33",
      revision: "041f97725a8b647b82fbeba971cb2caf84da68c7"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8be62389ae05a55188d956d24041a56cc38653b46e1abf047c43a31a40ded456"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8be62389ae05a55188d956d24041a56cc38653b46e1abf047c43a31a40ded456"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8be62389ae05a55188d956d24041a56cc38653b46e1abf047c43a31a40ded456"
    sha256 cellar: :any_skip_relocation, ventura:        "8be62389ae05a55188d956d24041a56cc38653b46e1abf047c43a31a40ded456"
    sha256 cellar: :any_skip_relocation, monterey:       "8be62389ae05a55188d956d24041a56cc38653b46e1abf047c43a31a40ded456"
    sha256 cellar: :any_skip_relocation, big_sur:        "8be62389ae05a55188d956d24041a56cc38653b46e1abf047c43a31a40ded456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0facb8a9351866bfa87f6120ef7a8ca62b1c2dfca3584ce395f47e4d9d21c1e4"
  end

  uses_from_macos "python"

  def install
    bin.install "repo"
    doc.install (buildpath/"docs").children

    # Need Catalina+ for `python3`.
    return if OS.mac? && MacOS.version < :catalina

    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"repo"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end