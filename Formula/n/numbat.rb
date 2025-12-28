class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://numbat.dev/"
  url "https://ghfast.top/https://github.com/sharkdp/numbat/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "ea690466f12684e2a10c771ac6e707ba0a080eff9ecbf506ef57b76f3cb589a0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22eab675af068ec0afbb943f720117fa39d72332c9b9a4d7212ad4e076794f99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b46a61fdfede6004c523ee6d8883c8932273df474a39cac6243b86ab89c1278f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff569175e9ffef20ac8040cfb172106dace0579f58c94ec8ec0293c6e045ae3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb67a39c7697809eec41281f41ddaecd0778ef9840f7d77315f15a2988e6c06c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebba5c2c0ec22396e635d4dabb78d0c1fb44c331b84c67f1c139aedb0ebbd9ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9246d86e7cd530d672340adf2c75af4093834398b8c86c559049b400365f0935"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end