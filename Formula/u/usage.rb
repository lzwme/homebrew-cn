class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "d6e4fb726c68c7737794db60e5c1b717ccf35b5e16ffc9c4eb42a06e95edbf58"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fb162e04d5c86f5e15932f55567276575c9bcf6a760b4a80f6965989196924e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14220fc716828a69f0fd9182d57d2c06e69e7b59a3b4d434fabc0bd4f0e82a62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b1704341600c6f880522ac34421d80d51973c61918e23c1521aadc3bfb829b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "78340f15c93daffdf5ac1fe52d96f26003864d2372383ea2fc200e2877d69d22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1f80a6ad2829c0316b7046b25eecf56ee5aae9ce3acf5e018a68a6e963550ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92520e39718bbb2c28cfe011e27ecd8fadab4acabad87c34778b47dfc681f3a0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end