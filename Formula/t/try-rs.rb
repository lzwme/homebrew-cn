class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3d6523800db064dd972b58a95ab0eef3de805d2feecad19d4e133033e768345e"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15f0a84f822694949a236b063b384373746bd76c7657d1ddc6edd32ad0efbbd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "785e287943cbb52c66e7ba6909570eeeb083b40fd9b2a2af81438dc783029899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42e0ec2fa5c83c5718d9f54b82e9b35774f16950ce05809632bc127e9058c23d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d992ed7c6528cb63de8e58a5e573e9c268123294353a95d8cd502078ec8171a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f9956152b2f3bb25db4ab8d2926b17887aee9eff6fa6c131c1407949584faf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d97a3fcbb46a46a3f9ba592c0afc6972e94a1e61c28f3106eb6e8c68ab32bbc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end