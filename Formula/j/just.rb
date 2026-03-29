class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.48.1.tar.gz"
  sha256 "290bb320b36ca118b8a8da6271660c941a8b0888b943de22e8238286e2312554"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "122af6b52fe76e64002593450d5e678d55c0e91bfffe2c171b87e10eaa5abe6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92472e1d6c139d1df68bb5fec328f92107c663ab08e9d73f0df265219632fd5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "934f9790656f5ed981e23bab856be0eb0d3f763bad0d3636449a5ab331e4904a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc0276946ac0a5ec336422e79e6f495ad626b38962dbcab38a5948487bc284d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5689dacd47295ea4b9bf46308355e5e5cc2a94636267bfa84816e30fe471dc35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba6971a03bd88adc6e3c05bd5d51d5b062219f631560b948130618502710c6e3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end