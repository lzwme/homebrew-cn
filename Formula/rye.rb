class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://ghproxy.com/https://github.com/mitsuhiko/rye/archive/refs/tags/0.10.0.tar.gz"
  sha256 "bcc7abbdacd4e7cf98f396fe5e199e3305be8e564ad50fe2592bd320fda70c8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9be0a6dcce2f06c16908f154d4b87ae1933a7f67a83b6efbde4f81a8598bf49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "016a0f2ce374d7694c1371e3bd3a33f981800ce26ee57e0fc9218a995a0118b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98265ccca60ce5f8c4236904f6374011e612f086d568309d55e14cc0e2faa507"
    sha256 cellar: :any_skip_relocation, ventura:        "e2330d2a5c9871490ad3a12190eeabc2c8d1112c364a8ca8d79dcbae8e162164"
    sha256 cellar: :any_skip_relocation, monterey:       "59b93ce7dc5dca1d5f2848c6a1ce0e710f7e1a74c6fdf0827cf62f78890a24be"
    sha256 cellar: :any_skip_relocation, big_sur:        "65348dd31d56d2a1b615194cf7a39c65911b70d2d1ef24d262cd59fb465838ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "967d6bbeffbeac696977c560403e67784ea8ab146d972f025e929018964ccc43"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin/"rye", "self", "completion", "-s")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin/"rye", "add", "requests==2.24.0"
    system bin/"rye", "sync"
    assert_match "requests==2.24.0", (testpath/"pyproject.toml").read
    output = shell_output("#{bin}/rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end