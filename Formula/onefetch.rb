class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://ghproxy.com/https://github.com/o2sh/onefetch/archive/2.16.0.tar.gz"
  sha256 "948abb476a1310ab9393fcce10cffabcedfa12c2cf7be238472edafe13753222"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5399c27570296ae42422c9e025ab5ab8835bb72ffcfba2b25041454f6b39a09e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd0d7efe8af64d480ffe3f6bca0ff137d84a455089890ba884cbf512157c6e9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d0cee2127e2a55eb5aebbb201bbc3211e41ee5be3e781af89493d9b5d08e596"
    sha256 cellar: :any_skip_relocation, ventura:        "1552dd38e68dd636888be0f350c8d98792e2ad8399de732fa129391241a526c5"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e7d389b7afddf3c6f25944694013be1f3353c7189c68a91e7c125edc53502f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cebaa0c3d054d858515378fa4fc84abb928853423b7f9ef0962660279a63791f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c0ed1915d92c86ee7c5ff6ac3dcb5074a1286c90a1418463ae1eeb31fbd09a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)
  end
end