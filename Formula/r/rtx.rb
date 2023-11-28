class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.11.8.tar.gz"
  sha256 "45099e8494004759dc85537304c608193d98cd3b5b91124f5a61d88592e41f24"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21a4be1251b36e352a87048995f2847bbf5fe651d448bf8110620410c8c47e1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e76c5964abad529f23ba813e5a6def222d9f184243c406ff04a1f86bbfbf0ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e68ee1fbb8a04b139b6f8f301ecea04e97c2ff0dfbcae1b93d05db997f608fa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "642896d8226374a04d7a1dec4178b5fc473105b3afd11ec01ca1d3db44343542"
    sha256 cellar: :any_skip_relocation, ventura:        "fe432d853f8d192dd74e404ad4f9e35ad6759bf4ebdfaba5cfb5b98552522119"
    sha256 cellar: :any_skip_relocation, monterey:       "b0d40992d557d49fbe88b8ae3413bdd80b01ebf2ff91098afeaa85e56e83bac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401e894b5a44bb2c117160ee5992d944f89e8c4e27aec2afb59742bf0b313feb"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end