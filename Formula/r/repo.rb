class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.38",
      revision: "024df06ec15d7304fbb5f9a2b1aa44f2af9daf4c"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b57bda4d4aa6637271e1d9ab21835655a7018f2323d9a40d5c1da8c403c36440"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b57bda4d4aa6637271e1d9ab21835655a7018f2323d9a40d5c1da8c403c36440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b57bda4d4aa6637271e1d9ab21835655a7018f2323d9a40d5c1da8c403c36440"
    sha256 cellar: :any_skip_relocation, sonoma:         "b57bda4d4aa6637271e1d9ab21835655a7018f2323d9a40d5c1da8c403c36440"
    sha256 cellar: :any_skip_relocation, ventura:        "b57bda4d4aa6637271e1d9ab21835655a7018f2323d9a40d5c1da8c403c36440"
    sha256 cellar: :any_skip_relocation, monterey:       "b57bda4d4aa6637271e1d9ab21835655a7018f2323d9a40d5c1da8c403c36440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d54decc71a0df3a9a37359d771bd18eda15e2c7d2820aa26c9ac378022b4097a"
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