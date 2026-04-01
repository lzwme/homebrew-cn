class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://ghfast.top/https://github.com/Skardyy/mcat/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "afa0fb5950bb3805808e9b265ec2af9244bea077468d14ed3447afbb27095c64"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3222d7ebbece6019175a31716496cdf33d266ee48570ca2ac0a8de6a1033ee66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a06be293bd223f7cd08a1533b613a65333fe38af565ef52fc2677c0eb5cb46fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f543e5cef02a1614e200c199e811ae155a20c04abdf82f4ab15b229b1c5e4d1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6d95f825dfa0362d483d09ab36c8232df39d055686098a60fcd1f7b290192ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddc0b3da952cf6c3971f80547269e0685779761c03059800c5fc3fc7c81a739a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c2446144ad858b7c8dec3f2bf1dca1453b2b4027ffbf1b100e2d9608a77baf7"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end