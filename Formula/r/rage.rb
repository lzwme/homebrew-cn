class Rage < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://str4d.xyz/rage"
  url "https://ghfast.top/https://github.com/str4d/rage/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "fb5255ff9faa944a15a128f812499cd5c08e6155790e284af34c914cbc3d0103"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/str4d/rage.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a541458898d1ec89d8b61cd6465a068e92c5aa459a818c68378b299533b19caa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d94f8da0e758d8e122e299f8993aeedfa0447321dc7d49be31b37028a2de101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "479eb0f4a6e6539043fa091b5c84915ff8019cd8cead8c9710f60a245a1b8029"
    sha256 cellar: :any_skip_relocation, sonoma:        "c261acbf15d358266a29802d2dff36dd23a2f85327a5b1fd97138526680243b2"
    sha256 cellar: :any,                 arm64_linux:   "4a8649a78795a902ce1d61991b4d19fce5f2fb5bb291c58f59b4c21d86d07622"
    sha256 cellar: :any,                 x86_64_linux:  "65b5fa946039e2ce122c24e43df8e44f8b5c77d84082d803330d7a7dc40151b1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "./rage")

    src_dir = "target/release/completions"
    bash_completion.install "#{src_dir}/rage.bash" => "rage"
    fish_completion.install "#{src_dir}/rage.fish"
    zsh_completion.install "#{src_dir}/_rage"
    bash_completion.install "#{src_dir}/rage-keygen.bash" => "rage-keygen"
    fish_completion.install "#{src_dir}/rage-keygen.fish"
    zsh_completion.install "#{src_dir}/_rage-keygen"

    man.install Dir["target/release/manpages/*"]
  end

  test do
    # Test key generation
    system bin/"rage-keygen", "-o", testpath/"output.txt"
    assert_path_exists testpath/"output.txt"

    # Test encryption
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"rage", "-r", "age1y8m84r6pwd4da5d45zzk03rlgv2xr7fn9px80suw3psrahul44ashl0usm",
      "-o", testpath/"test.txt.age", testpath/"test.txt"
    assert_path_exists testpath/"test.txt.age"
    assert_equal "age-encryption.org/v1", File.open(testpath/"test.txt.age", &:gets).chomp

    # Test decryption
    (testpath/"test.key").write("AGE-SECRET-KEY-1TRYTV7PQS5XPUYSTAQZCD7DQCWC7Q77YJD7UVFJRMW4J82Q6930QS70MRX\n")
    assert_equal "Hello World!", shell_output("#{bin}/rage -d -i #{testpath}/test.key #{testpath}/test.txt.age").strip
  end
end