class Rage < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https:str4d.xyzrage"
  url "https:github.comstr4dragearchiverefstagsv0.11.1.tar.gz"
  sha256 "b00559285c9fa5779b2908726d7a952cbf7cb629008e4c4c23a5c137c98f3f09"
  license any_of: ["MIT", "Apache-2.0"]
  head "https:github.comstr4drage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e67f141f38b2b412b46128c485063801adcbcf959b07534a8f551a52c4a60ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66ae99a18be59aaf0e4320d5730dd614b255c2dbb7dfb983ca99458c8853f8c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c083e92caadb55e63ba0a77f37e06a6e2c0d8bfdc8a60a3e19ccc4de0102745"
    sha256 cellar: :any_skip_relocation, sonoma:        "5030ea9c84062928ec800a5101edf75e70ec4459984aaa51858b9d250e80bcdb"
    sha256 cellar: :any_skip_relocation, ventura:       "c1ef3aec2a5cb8148d8928a1585142e9b761e2d0f35c1acaee7da19c0e3a876e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a45f4a404552dd7911b5f35180e7ca31a130628b420607d32c8699849deaa4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".rage")

    src_dir = "targetreleasecompletions"
    bash_completion.install "#{src_dir}rage.bash" => "rage"
    fish_completion.install "#{src_dir}rage.fish"
    zsh_completion.install "#{src_dir}_rage"
    bash_completion.install "#{src_dir}rage-keygen.bash" => "rage-keygen"
    fish_completion.install "#{src_dir}rage-keygen.fish"
    zsh_completion.install "#{src_dir}_rage-keygen"

    man.install Dir["targetreleasemanpages*"]
  end

  test do
    # Test key generation
    system bin"rage-keygen", "-o", "#{testpath}output.txt"
    assert_predicate testpath"output.txt", :exist?

    # Test encryption
    (testpath"test.txt").write("Hello World!\n")
    system bin"rage", "-r", "age1y8m84r6pwd4da5d45zzk03rlgv2xr7fn9px80suw3psrahul44ashl0usm",
      "-o", "#{testpath}test.txt.age", "#{testpath}test.txt"
    assert_predicate testpath"test.txt.age", :exist?
    assert File.read(testpath"test.txt.age").start_with?("age-encryption.org")

    # Test decryption
    (testpath"test.key").write("AGE-SECRET-KEY-1TRYTV7PQS5XPUYSTAQZCD7DQCWC7Q77YJD7UVFJRMW4J82Q6930QS70MRX\n")
    assert_equal "Hello World!", shell_output("#{bin}rage -d -i #{testpath}test.key #{testpath}test.txt.age").strip
  end
end