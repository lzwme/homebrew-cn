class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.34",
      revision: "04cba4add52b11a27d09d73c2cbfebcd67a1f2cc"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13a5123e69679718f416db3a6711a3cd56fab3a0883b9b87e6163c18cc7dbde5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a5123e69679718f416db3a6711a3cd56fab3a0883b9b87e6163c18cc7dbde5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13a5123e69679718f416db3a6711a3cd56fab3a0883b9b87e6163c18cc7dbde5"
    sha256 cellar: :any_skip_relocation, ventura:        "13a5123e69679718f416db3a6711a3cd56fab3a0883b9b87e6163c18cc7dbde5"
    sha256 cellar: :any_skip_relocation, monterey:       "13a5123e69679718f416db3a6711a3cd56fab3a0883b9b87e6163c18cc7dbde5"
    sha256 cellar: :any_skip_relocation, big_sur:        "13a5123e69679718f416db3a6711a3cd56fab3a0883b9b87e6163c18cc7dbde5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3241c4ee7e175f93297ed0d195b1804d72272bdc36855b4672e733e77d280d"
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