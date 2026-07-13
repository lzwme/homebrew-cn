class Lstr < Formula
  desc "Fast, minimalist directory tree viewer"
  homepage "https://github.com/bgreenwell/lstr"
  url "https://ghfast.top/https://github.com/bgreenwell/lstr/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "fec5f7444cbf32c826c10a932e30fdc1a1a4673828c11b82929c585e5614fbf8"
  license "MIT"
  head "https://github.com/bgreenwell/lstr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "040e0a5687896e60fedd14882998f80c474220a91460dbe3127a6cca8992a995"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ff998cd925db1aa69f57708a68f1b47d23f59ea332c39990c49e01b388a35f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26156c74033b5c9541b8daca1a3b0eb9fb65a063484ec18d174cec1fe57c96ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "af8453e0b990bd83fd12508f3750503393ebee4d5346dcf348ae376eb255856b"
    sha256 cellar: :any,                 arm64_linux:   "0821b9c6d5c475d18f4fe59990ef1925dd5c729893bbf79ef2ae4c4c41a4c5d7"
    sha256 cellar: :any,                 x86_64_linux:  "e494ed24dc59840d9336d746c7e74483e7d88ea6e0b981a1e4cef32db87b712c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lstr --version")

    (testpath/"test_dir/file1.txt").write "Hello, World!"
    assert_match "file1.txt", shell_output("#{bin}/lstr test_dir")
  end
end