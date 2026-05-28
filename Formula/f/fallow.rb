class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.83.0.tar.gz"
  sha256 "31a298eed2fee9ca710346127dea2bb702746d580b93a208dc0b28c0d8e6eaeb"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feddd4c5f64e3a5d932aa85ead9be90eb1b12be56ebc582db189550dbff64bf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7bacfd3b131c8a345f42e980f0ebf0840c356303d8f6420b15f7f17981e3ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52b026999aa2b0177ee43f43497198456e811f0d97d8b3b1cc9da652a894781a"
    sha256 cellar: :any_skip_relocation, sonoma:        "38bb2919e408c50d8e1cbb3b1c6b0d60c255a4734ed2cd095d0c756eee458afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4865ca854d4b93c683c74c46054b71f0aa5b9b88f2be41e8761e9c17b41f4e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5754166d057f979e43aa8c3012acaaa911fe29885e071e3390e757795c0c21b"
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