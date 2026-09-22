class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.68",
      revision: "8c7e0a683e88cf23f2c4765b26cfa1c917b660f4"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e593308b278d2455821256afffc47b99ea7af7a7b48a858c6af73140da59c9e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e593308b278d2455821256afffc47b99ea7af7a7b48a858c6af73140da59c9e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e593308b278d2455821256afffc47b99ea7af7a7b48a858c6af73140da59c9e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "938ed41b4440d148c9d60be7d2d38e7c87361db1c612e4541693aad5eb9b2a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "938ed41b4440d148c9d60be7d2d38e7c87361db1c612e4541693aad5eb9b2a24"
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