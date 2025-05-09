class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https:github.comthomasschaferscooter"
  url "https:github.comthomasschaferscooterarchiverefstagsv0.5.0.tar.gz"
  sha256 "9f2a6ebfef3339cfb13895e9233c1fef684c7d6c23d8b190b4435d369962283a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ba20ec308eef2776b870a67c7b9813873ea42cc32d215baa8b1095f905c415"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e864afd07c9c80686178d2922b56ef82c1ad95e9c64082a4d2f011f38006e52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25e8fa0e7e55b2d7217f58e09f7354e411e568b054975f25e60f0699d9b2570b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c32af36768fb79760b6470c7ace69bc8d70d8b06be0f4b28bd68b91e7d292e36"
    sha256 cellar: :any_skip_relocation, ventura:       "b8385fbe6278e4a9488a3531cc5ef4866206d057abbd4144227d2627855e2a93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eead88f88ea430110aed85847a748c83e27f4406d62086f1394cccde34339213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f91050c73e974920a68d7639f7c9aae4aff48c7c8761e03c16559a2bdf92c357"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}scooter -h")
  end
end