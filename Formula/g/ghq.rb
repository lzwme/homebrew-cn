class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.8.1",
      revision: "21fb2efbea69d2ae2e4efeaa45a62329936e15b4"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a32930d3445915de854cafae0923ef68a302288aae1467cb032bb3c22510110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "967a8b8aec3d7abf6973eef43c53d89e0da43dd8938bb1e287642824fe03ffe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12449e0faa1872084ba8cfd12f6dc10fc329a08371fe527f65d9829418db9d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b441650b9a6f45c3228317d0af0fd6d5d1e5d2658db995e631e63a7dec3ad43f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c851697d7e482d35b8e8bf1c31dd6edefb8a3318df1a0e1284f0549db68d71a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e176694e52de0ac6c9484a751801ed25baecef89ea6b081b18a9e47c2494f07"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    fish_completion.install "misc/fish/ghq.fish"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end