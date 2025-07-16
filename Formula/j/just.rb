class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.42.2.tar.gz"
  sha256 "9929acc303b881106d2bf2d3440d44f413372c14b0e44bf47cda8ada8801553a"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6865423ef02c5e338e0dd44c5480efbde26184d82620eaa9525911ba39d23c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fe633c9f85b2224a2e7187f35bded25fe92370ed05840941353045e9e5e96c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd880dae39762ed94436b1823eb04399ce8bae0debae5b9b27fbf00fdf2f90e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f75b6032b6eda0d5c7f060fadf1894e8608495c61a64dd6baf06db7b87bbed"
    sha256 cellar: :any_skip_relocation, ventura:       "84010f01212b6c4006c8418c5da93f0dfcafd58d3bf62e40446b140090039c53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a55a8d10d8b636ed1708df081231186e1fae1ac3b66fb7263fb818bc0806fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a4dc788024935228e7c117534d653d23800775c4c006f2f15bde433b9e420d7"
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