class Mlc < Formula
  desc "Check for broken links in markup files"
  homepage "https://github.com/becheran/mlc"
  url "https://ghfast.top/https://github.com/becheran/mlc/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "50d722891b9590e53b979e2d041eaf10f69525ffe1a0f40e12596fa4f0caaad5"
  license "MIT"
  head "https://github.com/becheran/mlc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "532bdbd56e26cf5cfe0c02c4de8900748254a73c22734766917076a8bcfcb918"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b62de83cde12fbb0495dad8e166f3c72e2ec3ede4fea76567122a4b166c0d246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5c6bc01d6066198657e957fa60115d38a8474cb78337cb3f612b96180485ffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "50f46f27eb98d2d61bc86296faeb652ca1964e4d0fcd4278c7e1269338b617d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e904b5577469d998054529e6554166ead14e41631d65d7a31d6fbdb9b72b598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e251f6749041878e9d62dc8063b155bdc5e423501a62fbcd37b8afd940bec8f"
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

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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