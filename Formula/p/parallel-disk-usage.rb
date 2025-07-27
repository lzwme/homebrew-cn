class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://ghfast.top/https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.20.0.tar.gz"
  sha256 "12d27416a447eb7cd50a17d229a5d2b7d6342bdae578d6ddad137292da176ef7"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e79b896ec4bb73e50d3e9ee57a2e62107738bef677d798a85d5135d120b3d3f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0608827d6ef50890bef1c194cfe39778a05616d00261013cc4befb7000786948"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1b67979d5303ec33a23d777fd0743abec111bc12e178fba48c1e0c671cfffe7"
    sha256 cellar: :any_skip_relocation, sonoma:        "05e9aad6717d00c17e215d58ca9dbad6a16faa676c6ab0219c2aeb50b2a0f7be"
    sha256 cellar: :any_skip_relocation, ventura:       "d0b82d4e2af300d6e04fca9959af4c7e83c83d921d04854019423769b7ec2261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58b3d1ab64cb4769a4a0e1a36e8741c9483743149abe0ea98331a740d057cf66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "129578a120adf3098c00c90ec831e522661ee21e454b0ce45829c6cef0356497"
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