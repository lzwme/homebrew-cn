class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.46",
      revision: "0444ddf78e3026056ee3786119e595909c039ff2"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a2a57c781133cac0a369f20ef1c97497a55037e69f1fc645947cd87d96e927d3"
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