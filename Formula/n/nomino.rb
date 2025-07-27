class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://ghfast.top/https://github.com/yaa110/nomino/archive/refs/tags/1.6.3.tar.gz"
  sha256 "4868795b6c8a1133ee1c3b19f7a32e0fb0d0a0919b07ccadc4fa1f7526acc86f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42bfd8cf82f4d43289406b61cdee3ea3d02f0fc77bad625de5c6ce4332f850b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20c012c7e48c0e97c0f329dec5caee2af1d6634f911c6b35843c492075da1367"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34ab873709e316fad6421ec7820a7b19f873118191f811b0125ca7023c50e840"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ffdedac45bc801f80ca05ff06c00de05ea1fb1008f0635a1f0a60a49880e1e2"
    sha256 cellar: :any_skip_relocation, ventura:       "352e22303c8283a6540d464b1a9d62a8259a1855113e744bef40a2701a4bcaa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d44a8f762bae41a49df265a031f96bc30e7d6b080f03f25076fe4e114a4c39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f94db8ed52f15afb5f1fda7545cdbd581cdde13d24471c25622cf7aa62dd7e05"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_path_exists testpath/"Homebrew-#{n}.txt"
    end
  end
end