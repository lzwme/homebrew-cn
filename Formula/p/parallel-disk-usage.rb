class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://ghfast.top/https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.21.0.tar.gz"
  sha256 "7d049539cdb8db8ff450e5b5e88e038a8a2bce10d8e7ca9afbba9783bed33433"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f4b889c2b7adc18803922bc9b3b3f0604e3570f70c9ce7fd886d74696ad5fb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f23305a44691f9f942d4f732db090607f95380321bd288685ea52fef6df5be8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f388db0cdc7fac5d211762118d7472799ce98ad1de664c6314169842055ede13"
    sha256 cellar: :any_skip_relocation, sonoma:        "730ce7fe72fce01f841f90a4755f6ce434aa10d24e3c59f0a99dbdd3acbfa046"
    sha256 cellar: :any_skip_relocation, ventura:       "850eabed650d975f737b1443bc38cd12cf7b7d14bf16a930cce7629832ae69f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "defdd39305f2aa151cfb6286e681ae9f7efa5e84960d69cdc8f2a45600e3c26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56683ae2c971e61d703bc85ee361c88af2bb6229c68dbea637e2783da73a8572"
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