class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.26.9.tar.gz"
  sha256 "307fa9141193bc7df6c60d7b5f0c5e9d403e9dafff3ec496809325c93ab17bdd"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d82aeb1d3b9dece91787e0839526e9bd0e2983947f2537a10dc6a46d4698bec8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cccbb4d4d83255e997be9fc4fbff4975a710bb590fa7a6bb4a700b3f4e8dd63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "445a094b369eca75c94513a95d37b6b2e76c351b9e395cbdba3fc05dbef46229"
    sha256 cellar: :any_skip_relocation, ventura:        "e703d625490a0293850cb9d11740ac7b1f8bcc023108e6849cf6b09b5a34cb50"
    sha256 cellar: :any_skip_relocation, monterey:       "670817518622438356c221ddb3fdb87d25476349274e8ced5ebf1db9d1ec9100"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3c603a572662c10cb998592e3c95fc84356ab297efc7c933ddaac44dc80317d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e022629080e1d1386f53feff364c81610862591528a47da121fe11da650e734"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end