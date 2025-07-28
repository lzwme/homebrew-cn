class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://ghfast.top/https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.20.1.tar.gz"
  sha256 "619ff1040f2dd1596d1d68be6f9e335f29d9b7d520fe50b471db31b61b31a5eb"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa486c22e8e074b72acac391eb444bec34636d2d0444c2e1664502347778a80c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36babc9574a2ee65950da0f1eaf5a528c47c67cc6d641c48ddd406847140b037"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "875c710651ca7baf92b8ae56943f8e21f29322544a0736dcd49fbccae2fb89c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f7b88d75ac05b87a8e83c0d89d42c8495f767631f24c22ae7645c5edfdab14b"
    sha256 cellar: :any_skip_relocation, ventura:       "c4e7ae593a591b9ff250a5add0bff6729644ca1305b3516dda0570e753e509b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e757bc959e9b3fa2b423b86b3138b4da6cc895fa5fb4f649fb8993e33f696b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25f538d26ff2ba1199809585b2ac861e961de1cc7f14966d33e0468f572db098"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "cli,cli-completions", *std_cargo_args

    system bin/"pdu-completions", "--name", "pdu", "--shell", "bash", "--output", "pdu.bash"
    system bin/"pdu-completions", "--name", "pdu", "--shell", "fish", "--output", "pdu.fish"
    system bin/"pdu-completions", "--name", "pdu", "--shell", "zsh", "--output", "_pdu"
    bash_completion.install "pdu.bash" => "pdu"
    fish_completion.install "pdu.fish"
    zsh_completion.install "_pdu"

    rm bin/"pdu-completions"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdu --version")

    system bin/"pdu"

    (testpath/"test").write("test")
    system bin/"pdu", testpath/"test"
  end
end