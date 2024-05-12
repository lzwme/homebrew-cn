class Sigi < Formula
  desc "Organizing tool for terminal lovers that hate organizing"
  homepage "https:sigi-cli.org"
  url "https:github.comsigi-clisigiarchiverefstagsv3.6.4.tar.gz"
  sha256 "3c41ebabcef294d109545a7736f2d6f62532a107375566f8fe102414367eceea"
  license "GPL-2.0-only"
  head "https:github.comsigi-clisigi.git", branch: "core"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "720f2b3d7db7549d9971cc1e6b06600fd4093ddf79f8930c5b231744fe96a7aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4e8c67b3aed0bdda931fb117f499f6a23b0c3f7d908be500937551de386c8f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f182faeae4553760dfdcc17f0ea9364e2e7247f3432d92a25a41100fe1ec8f14"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8a9b22a2f70df6648d4bf188ef119c8d2425be1bf8d7a958c8ae1556f51dd21"
    sha256 cellar: :any_skip_relocation, ventura:        "46ad59f3b76ed015b310f1f45a8c3b4554c9eea9b26489baedc7db11103d3726"
    sha256 cellar: :any_skip_relocation, monterey:       "183f2a38088157ddaed35b702bffcb6f87905c26a1ea9e9e9be2d8a0cf8a8f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91d48b85d3a4962aad922b3877bcf860178bd94eccec9a2a46571365e7c1997e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "sigi.1"
  end

  test do
    system "#{bin}sigi", "-st", "_brew_test", "push", "Hello World"
    assert_equal "Hello World", shell_output("#{bin}sigi -qt _brew_test pop").strip
  end
end