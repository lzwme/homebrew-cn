class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.47.0.tar.gz"
  sha256 "6b5d6f172c8f1c7babd0d76047143741b54b54d62e2abf4061863b24931461d5"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81747bd17e7d8752ca0d3fa2d528b88900c99920b6befd96b94e446ed70e5752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8db5ecd716d358c28d3c44edeb1f872b582f937436225b53e5359a8fae1772a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d4fba979a7023225fff17559603dc39bae27c0128b5fe595f77b36bd0e2ff45"
    sha256 cellar: :any_skip_relocation, sonoma:        "85c194c84125e77934ef95eb5c95b987b85f10e3b74e41e8ac051e19f6f7c070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ac7454c035f7328b9997735c3c1c3f9cb2c7ae74ceab1eadcb9720c5acb8d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fa6215163c5248b4d2bb620661c8396f934be0433bfc035149e396f3521b6d1"
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