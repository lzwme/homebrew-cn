class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "e69d302e97856094f388a9376ac5daf99278be95aa8238045985464f3d48ffbe"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61262de34252628f3498541caba0299f3abedc432b45105d5bc033e7463c2e1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "450e0da42b5f6a67ec051fe7ea3de57c602264c615fbd07c5486a517fc109a7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "168cdcec51d4e4cd6660dacca78c820ad6361a3091876c7d4c77763048c147d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd950b4d206d057c94d3d9513eaf4ed232e5a7ee92f2fb52061f3eaf747c7450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b921548db7a5c0c8afaaa05ccd094da523154ca3ac26a1b49e382908b1f9aa10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca90c71ede018d750d4628f951ff7394ab3d952b492010a3ba967de4e54ff10"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end