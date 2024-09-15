class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https:lune-org.github.iodocs"
  url "https:github.comlune-orglunearchiverefstagsv0.8.8.tar.gz"
  sha256 "6cb6e9e1efc0b27c2470fc21032df68489d7d3af2fbc67dc7f02a94c9fe5ce76"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8c007b4a9868b348b25fb204c4382c832909161d5cbb2976be92a9fe4ebeb5cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4de68783b90e96d59301a263d7797c23da68500dea479c1341f024a4596b351c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f2403bcfaab0697445f43b79c253ef7d11150408e8599aab9ebd3d86fc98279"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "291ea23eed1192fe9e33385ba858af6422901f8a0bcfb08faa091f22a43bdcb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7f6554e43764e80ab3b0d5d243bc054507cabb9ef81e70b7315cad2b8f9d3f4"
    sha256 cellar: :any_skip_relocation, ventura:        "f4a3e85bd256d0319655e00a317d796b08fa2e2acf65e1e81fc5e80fbfa83808"
    sha256 cellar: :any_skip_relocation, monterey:       "077c9734c72af9f3cecebb80e0ca0b6de8aa5a7cbe01f828c9a78f8aeb20cc15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14f4985d0d02de9df3ba983268e8239c624440c9470d6d3abd339f9f20759361"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crateslune")
  end

  test do
    (testpath"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}lune run test.lua").chomp
  end
end