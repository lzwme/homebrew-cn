class Mlc < Formula
  desc "Check for broken links in markup files"
  homepage "https://github.com/becheran/mlc"
  url "https://ghfast.top/https://github.com/becheran/mlc/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "6584889f81406f905d38bf624815861948abe62a13259a7a6805a00109f89648"
  license "MIT"
  head "https://github.com/becheran/mlc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b8bc74070f12f643d8dd7d94909b431dd5d6ff4f7002b59841a2d54f7cf6ba1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee8c1d98726c59dfd60eb0d6df4eaae8fa087c97d67a3554fa111d8077920e59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6708c54bf42a1f1e9cd02b5ce69b467e2e748a5b180839c492c2a0e185f296ae"
    sha256 cellar: :any,                 arm64_linux:       "51d010447eb946c2649e8c9afb635449b949d3dff4d7826b845208373a91e376"
    sha256 cellar: :any,                 x86_64_linux:      "e993a1d09f938bf712f33d0dde8cc277fd95b73c87dea16ab1572395cfdd3003"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    # Explicitly set linker to avoid Cargo defaulting to
    # incorrect or outdated linker (e.g. x86_64-apple-darwin14-clang)
    ENV.append_to_rustflags "-C linker=#{ENV.cc}"

    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

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