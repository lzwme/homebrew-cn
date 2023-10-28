class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.39",
      revision: "b99272c601bc5f466c3cfc782bb852c2c967ad27"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c9acf142568e72443c7a8ce2ae7eaea4d73f5b36b657376e032828351908b92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c9acf142568e72443c7a8ce2ae7eaea4d73f5b36b657376e032828351908b92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c9acf142568e72443c7a8ce2ae7eaea4d73f5b36b657376e032828351908b92"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c9acf142568e72443c7a8ce2ae7eaea4d73f5b36b657376e032828351908b92"
    sha256 cellar: :any_skip_relocation, ventura:        "6c9acf142568e72443c7a8ce2ae7eaea4d73f5b36b657376e032828351908b92"
    sha256 cellar: :any_skip_relocation, monterey:       "6c9acf142568e72443c7a8ce2ae7eaea4d73f5b36b657376e032828351908b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f29e5f5e11ad48e94c62ac693439a99cecb1ffdff6e19999c7f932be2f39bdbd"
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