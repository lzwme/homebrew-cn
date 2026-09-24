class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.68.1",
      revision: "e1e215a14ea5373419acb8753b6865de19d1f122"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77395ec79df4650f0c3ca246a9f4ae788aefa9d00b3902839d2e378511e18fb2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77395ec79df4650f0c3ca246a9f4ae788aefa9d00b3902839d2e378511e18fb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77395ec79df4650f0c3ca246a9f4ae788aefa9d00b3902839d2e378511e18fb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c4fe914d3de83c435ca1571f391d9895329633f2d375b7b244fb53781d1e176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7c4fe914d3de83c435ca1571f391d9895329633f2d375b7b244fb53781d1e176"
  end

  uses_from_macos "python"

  deny_network_access!

  def install
    bin.install "repo"
    doc.install (buildpath/"docs").children
    bash_completion.install "completion.bash" => "repo" if OS.linux? # needs GNU sed
    zsh_completion.install "completion.zsh" => "_repo"
    man1.install Utils::Gzip.compress(*Dir["man/*.1"])

    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"repo"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end