class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.36",
      revision: "6447733eb28ea188d551ae518a7e51ebf63a4350"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "644bec848734e22b305cd8650a83224b0d129b0220177d8025e7f1de6a2975e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "644bec848734e22b305cd8650a83224b0d129b0220177d8025e7f1de6a2975e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "644bec848734e22b305cd8650a83224b0d129b0220177d8025e7f1de6a2975e5"
    sha256 cellar: :any_skip_relocation, ventura:        "644bec848734e22b305cd8650a83224b0d129b0220177d8025e7f1de6a2975e5"
    sha256 cellar: :any_skip_relocation, monterey:       "644bec848734e22b305cd8650a83224b0d129b0220177d8025e7f1de6a2975e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "644bec848734e22b305cd8650a83224b0d129b0220177d8025e7f1de6a2975e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70038b96d2418891f82a75ae3074f25115e0b55d357351ab09c7a7435d0f55a3"
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