class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "a9381e4cdbdb620092271beb5842e840a254062e51d64eb56db097035d4c574d"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d7778003b6f88c1bc3ba7458d205949f3af1e6b2181d7efc1f9538b7ac05b7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10a9ec2fee39d2d076c1bc6f2e1ef2af5f118b0a1f5105553a3a5dfb2eed0518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dc2ed3956032d5e63364b30dc2bfd2b6d42d507cdef248301b266a47d7f6a27"
    sha256 cellar: :any_skip_relocation, sonoma:        "563ca84c89e2a510099954beca75fd5d8fc322135c2eb3f723cd59c0a460b0d1"
    sha256 cellar: :any,                 arm64_linux:   "36a3ff88173670928168198444c08ccf37201723fdf5e11b6cd084266292822d"
    sha256 cellar: :any,                 x86_64_linux:  "91824fc1647140a4b946ce901ce2c6ac173b139bb116291aa94b22fc8d87a47a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")
  end
end