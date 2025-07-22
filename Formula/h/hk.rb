class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "ccb22f9683d3a20ea68b6dbed56acac7056812e955b85d6c2b90da4a5e583047"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f6f94d30f983d330c9180451fc49c43917f45e455cea87509b035c3b54556f7"
    sha256 cellar: :any,                 arm64_sonoma:  "6fa6ce07c871903956cb6c1e9a2061aa87a36f5b09b5da617d50b333ab1acd26"
    sha256 cellar: :any,                 arm64_ventura: "0698a592b0499a8ccb63cd7d0cb373828955235d942de7f680eef89cc85bbe9f"
    sha256 cellar: :any,                 sonoma:        "fab275e688270087df38407fca4418a3dc17b852885cfccc36a2366814a303b3"
    sha256 cellar: :any,                 ventura:       "7c95ab7e4b4604533b074d52cd85b388e53a8fa6b72fe06c8a126978d74243e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7174c9b8708f258b8cb4d8542d9ce64ce039c2adea9009656ffbc3b0ae65f996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f4d917adeb58d92cbac14ea46ed9ae5d4a57b4af55f89bdbdc42bc62635367c"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "#{pkgshare}/pkl/Config.pkl"
      import "#{pkgshare}/pkl/Builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end