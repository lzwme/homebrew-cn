class Topiary < Formula
  desc "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem"
  homepage "https://topiary.tweag.io/"
  url "https://ghfast.top/https://github.com/tweag/topiary/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "88f90418b9a87f8b80d914f8cae00b173b5db9961ac9bcda4c063d6ed4b76aa8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d63d024bc5ddd00ac02004434c7c107bb4fe37310994facaa64f4a6f458df37d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30a66cb9ec015233b5f91e1380b0bd1b97fe5f90b95c3bfb8cd5233a84c99aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcdd629e1ebcdbd523edcadc4f9623a27c3bb19bc973a96595bfbf3ab9e2e270"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f6944a75a4096bf266677510d6edf76c88709df1f49299f916261ddf23d2816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "761c4d8c2d993d393abdf4ae4da47f6a05423c6ffe3cff9e8e0385e1210be545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "108b8746d36ae57e0c9f29cd5d4114ab4f1a0694cac7da7223cfa8d18e49ca10"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "topiary-cli")

    generate_completions_from_executable(bin/"topiary", "completion")
    share.install "topiary-queries/queries"
  end

  test do
    ENV["TOPIARY_LANGUAGE_DIR"] = share/"queries"

    (testpath/"test.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    system bin/"topiary", "format", testpath/"test.rs"

    assert_match <<~RUST, File.read("#{testpath}/test.rs")
      fn main() {
          println!("Hello, world!");
      }
    RUST

    assert_match version.to_s, shell_output("#{bin}/topiary --version")
  end
end