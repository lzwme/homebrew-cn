class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.44.0.tar.gz"
  sha256 "95a797d023a329dbd4d4a87ad6c0ee6affa2efd15be266b83f7f2868a03f5779"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0aab34e8074e0d5fd8df2b351f925c551464d276639ea92c01bafe8b3430fee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44743caca8d9a40982862c6b542d53d766bc4b3f6a4ee3f77da36837a1763a02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66cd9ce0502e62989995329a6b9ea2a16ddff7c0080c027489841fb4b9023220"
    sha256 cellar: :any_skip_relocation, sonoma:        "35a69d8b2770aeb591acd3326531fecbdfe58dd49ce7d1545a97104422144ad4"
    sha256 cellar: :any,                 arm64_linux:   "06c1618c306e3740a5b4ee3a7f1cb35ca4b6f91d0a158cf3ec0c182c74908c8f"
    sha256 cellar: :any,                 x86_64_linux:  "07556ac88e4ed3a1c61ecabe21ada4413a5b88e978b5101304b2effa942784f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end