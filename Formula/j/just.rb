class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.48.0.tar.gz"
  sha256 "fa7f1bae65b22745a6c329f3c49b9876aa159b4e04d7803d78660809fc8af7d1"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41d75bb583d276eb19af036c31f4fc9d35e0e292a8ef4725f9f1d4500c14e273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "522824a58f9ea482761eb30a5990db2e633eb87fbfcb0be6e348a7811941b173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3623bab05c8607009467a125eefd2099e868180da7c8a67b53233c693ccb5b86"
    sha256 cellar: :any_skip_relocation, sonoma:        "a26bbc8e535770f3c27c22a006864958ced1b872f2908d99f8dce8bbb810de2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60fd555fe791eaccfc9b48e330fb0ffc37a57fc0acee15414c733b4a4a9450ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d24f46472f08596001e9b4f92cf7243af6cf0a202efed63f167cf84d8f9992"
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