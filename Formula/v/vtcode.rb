class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.76.0.crate"
  sha256 "c8cdedc4d6dc9ea0fea3ee801af099c3c0a0247394e8d4e498560bd1c55ef8d6"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3838d8ddf16579e84325524e1bef1b1d6d08bb98628bcbf6b0c4b9fce14152d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1936386197fa28be8bda357e2536c73f467e8156e54d9a2a8fb552ac9865573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8acb88eb6995319361de06b82c6c752a4bb7ff2a5064b392d7069e57a7df6d1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "56aff646938c7cb385b1589c54ab4b026bf24c7672e66cbbd9e34e93dadb3e9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e17f696d051157457ad44013623bb4c8ebd226bc1a17049ded83dccfa6d51c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e5a5b6e3c5cce67543fe0900d8409576c6eb30731a8a80e976b4c6fe107eed2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end