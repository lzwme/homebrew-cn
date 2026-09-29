class Mlc < Formula
  desc "Check for broken links in markup files"
  homepage "https://github.com/becheran/mlc"
  url "https://ghfast.top/https://github.com/becheran/mlc/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "6584889f81406f905d38bf624815861948abe62a13259a7a6805a00109f89648"
  license "MIT"
  head "https://github.com/becheran/mlc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c3c5f5a686e1bc92d5f2696c5ce29e04a4efe8c16aa0aa94e941e69b3dba430"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc765fc7e22ea474b9a7ef126b97f291079006a080690789094fd20ecb9e6acf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6b7da6565800a35524e61d2bc631bc109851b9e904f0b09eb340d0aacd6936e"
    sha256 cellar: :any,                 arm64_linux:       "1031fa9d0bea83836ac749d2275063891b1eb7bb02aad2a8eda00d6e81283a0c"
    sha256 cellar: :any,                 x86_64_linux:      "c349128c6ee20000b39b842bd8d2e7f7c788fce4dd1d3b0095a7e22b678cb6fd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Explicitly set linker to avoid Cargo defaulting to
    # incorrect or outdated linker (e.g. x86_64-apple-darwin14-clang)
    ENV.append_to_rustflags "-C linker=#{ENV.cc}"

    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mlc --version")

    (testpath/"test.md").write <<~MARKDOWN
      This link is valid: [test2](test2.md)
    MARKDOWN

    (testpath/"test2.md").write <<~MARKDOWN
      This link is not valid: [test3](test3.md)
    MARKDOWN

    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+0/, shell_output("#{bin}/mlc #{testpath}/test.md"))
    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+1/, shell_output("#{bin}/mlc .", 1))
  end
end