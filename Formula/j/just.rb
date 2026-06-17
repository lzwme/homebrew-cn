class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://just.systems"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.53.0.tar.gz"
  sha256 "9742f15ea4e6afd4bf9b8fecd0c5ef61904d3d187f24675601fdfbace885a4c3"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5db15ce23635e686a55f6074f25c06a4dd81ee843494de3bbf9ef552cc33d45e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cc2c9f2e6c2396244f3f8817efe8435636cef25ed80c953b4d7c5315d912cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94eca2c7299abe9abb47efcb2e3e4d0e334e7f83de882614b1e102b3811ad66e"
    sha256 cellar: :any_skip_relocation, sonoma:        "29243b297a6dcd2e2d06acf857ad7010910acb8bd25e0b64b0c486412fadf4df"
    sha256 cellar: :any,                 arm64_linux:   "5d6dc820c2319f218f3141afe2cbee382be08873a9eef1d8a7474cc4e799e2bc"
    sha256 cellar: :any,                 x86_64_linux:  "b48de9f02e456f5bf01de14e294eef02900710e05cfe6a0c09cc45e438eb019b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~MAKE
      default:
        touch it-worked
    MAKE
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end