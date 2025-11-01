class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://ghfast.top/https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "6ec9096049110c3fa47068b9c91affed522e065156e3261989677fbfa2b11b37"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc3423413920ca1cee05b31e2c2163139a62aeeefc4e2543db49f0ec124c05c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc3423413920ca1cee05b31e2c2163139a62aeeefc4e2543db49f0ec124c05c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc3423413920ca1cee05b31e2c2163139a62aeeefc4e2543db49f0ec124c05c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aa1f068d350493b5e364c216f02217cf573297f31239750c8b94fcb0ab473ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57484960b91b80ffefcc4aaa13a17454b5e688bb3731d0d9952e1cb193ef715e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c5dd49ac5871e97843d57699a21fe19d4e09bffe35383f5848235950ebc802a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end