class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.7.tar.gz"
  sha256 "0c5c9156dad5776b88079e85d98bcca9a6c8bc85ebf910c3cd26a9488a31fff7"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0375a9bb49009104a607a6ab6cc9be2df32ef71e944f62f6691c5fa84bb850da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "352f214128306758276f1510f6661268bf7bff0d481d8edb032a7d6ca18e9b7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30574582f83010ee09e0ee03c155e9e8d2fe7902337c4f4ef0acc7dc764152b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "46569fd796083472291a80d6f0cc57a5026a019b6507d4d59292d887dc619e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "2915655902af32d8ae7622638e7cf4c149bbb0532f86996d190206b3c8ff2bd2"
    sha256 cellar: :any_skip_relocation, monterey:       "605d1bcb4f712379f072921f13380c3c3ce4e7ee8b9b5d2388a104634391362f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b56b55e91bde9fb793871074f89fb2596917f29ae4ee49d6310ce8d8311056a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end