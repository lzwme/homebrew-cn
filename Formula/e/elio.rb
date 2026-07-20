class Elio < Formula
  desc "Batteries-included terminal file manager with rich previews"
  homepage "https://elio-fm.github.io/"
  url "https://ghfast.top/https://github.com/elio-fm/elio/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "e99d3b8403a3aa77eda5ab75d88f47a5b39468a82df530059af73485c149b7ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5753b03d17c2355a0cab5ec31632eb6a04b9f0b1f0eb7efe15e5b72620d33de7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2172601455e23af52b5f1ce2dc1db7e664fc2dc8ee4d5a1e424a3cb105bdb5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5e29fd4f4cb3a2fac506e19e160ffafa0ea20c45fb5cb037c0c86f30a4165f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb8441b7e4db8f4844fa8d9aa54f0a82ad5399bb25d05cd13e0f2d8a4ca2799b"
    sha256 cellar: :any,                 arm64_linux:   "150238d109954f0a661e2d8c14c9569fef3474b84081cd87ad82ae749725aa41"
    sha256 cellar: :any,                 x86_64_linux:  "aa3c38af0a8f56fbfa27f957ed6759bf9f1f03e52a2f8818e73155cd11e61087"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    missing = testpath/"missing-directory"
    output = shell_output("#{bin}/elio #{missing} 2>&1", 1)
    assert_match "no such file or directory", output
  end
end