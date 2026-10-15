class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.69",
      revision: "a0bc2b14a30bef631b91a2ca37c5254d9af44718"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f34672379ad199dfabbfe96b15930f7e83fdbc375776bc38a8e01813dae7de7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f34672379ad199dfabbfe96b15930f7e83fdbc375776bc38a8e01813dae7de7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f34672379ad199dfabbfe96b15930f7e83fdbc375776bc38a8e01813dae7de7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "da56a49380bcc48a7a727ec9eb3a0a3d805a225cd9f2ec15ec84dad3ecea0dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "da56a49380bcc48a7a727ec9eb3a0a3d805a225cd9f2ec15ec84dad3ecea0dbd"
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