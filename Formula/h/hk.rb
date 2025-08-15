class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "c4a224718d047ee6c2f5b7230d08b83fbe65bb75b4b67d1aa0b5569b3fc6fca4"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17eb42c09b0aad975bb8e5027cbbcb376fa3cdc37769ae8fd96218510eafc5cf"
    sha256 cellar: :any,                 arm64_sonoma:  "98c88cb1e4a89a67fa28af8f54fbb3e7f779d4f13f921b901cfe660740f7f2f9"
    sha256 cellar: :any,                 arm64_ventura: "fc784cf23a1a9dce84f938116665c48af7ca467ae1f5e975ae04aca9fc38022d"
    sha256 cellar: :any,                 sonoma:        "d64e10573d03fb78e350839d73e6c90cc08b2eaa55458b11df74ba7dd93b5056"
    sha256 cellar: :any,                 ventura:       "5c1013cc6ca19b5a37b58b8e4d19c72fc9a03e21a94545d6669c7cb18f70647a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa5f379ae9e9edce6a7eb79a3f3130e9dc30e12189530d9027d2d99beffe0ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e21c07fd002ddd42ddfc053c7f18fc1084b68f72b9811291a85cc71ea1848780"
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