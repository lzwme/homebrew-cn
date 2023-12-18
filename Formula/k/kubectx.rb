class Kubectx < Formula
  desc "Tool that can switch between kubectl contexts easily and create aliases"
  homepage "https:github.comahmetbkubectx"
  url "https:github.comahmetbkubectxarchiverefstagsv0.9.5.tar.gz"
  sha256 "c94392fba8dfc5c8075161246749ef71c18f45da82759084664eb96027970004"
  license "Apache-2.0"
  head "https:github.comahmetbkubectx.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "605e0eab94d6af055cc25cc91c6bda597d360e55fb7b8cd0d6d2aa678a991782"
  end

  depends_on "kubernetes-cli"

  def install
    bin.install "kubectx", "kubens"

    ln_s bin"kubectx", bin"kubectl-ctx"
    ln_s bin"kubens", bin"kubectl-ns"

    %w[kubectx kubens].each do |cmd|
      bash_completion.install "completion#{cmd}.bash" => cmd.to_s
      zsh_completion.install "completion_#{cmd}.zsh" => "_#{cmd}"
      fish_completion.install "completion#{cmd}.fish"
    end
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}kubectx -h 2>&1")
    assert_match "USAGE:", shell_output("#{bin}kubens -h 2>&1")
  end
end