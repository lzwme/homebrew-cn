class Rage < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https:str4d.xyzrage"
  url "https:github.comstr4dragearchiverefstagsv0.11.0.tar.gz"
  sha256 "f5c37b27428ad2b9ed91f0c691612dd0f91044d17565edf177fb676be4af1d35"
  license any_of: ["MIT", "Apache-2.0"]
  head "https:github.comstr4drage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c01e7c4ba4c3cfad0a74c14ff32b25e4642f0962056e73518226cc71c121e88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15a525b3085b4ffdd6ac02bb665e1c765eb3ebcfbf7addff382273f6466550e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bbf8f7d72e70891850c66013159c2b961618b376b368404efb55d5d78bd6b84"
    sha256 cellar: :any_skip_relocation, sonoma:        "0be2efd3da88b4926c5a0e1b2aa2c6d5148a8c6ff1117bf796c026df175fa882"
    sha256 cellar: :any_skip_relocation, ventura:       "583714adf952ec6658bcdf237f795dc052436ddf144db192875a7dca991de6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ce0166f53aa84b5dead2794a9b27d23e53bf863db4399ef470bebb7b3af34c"
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