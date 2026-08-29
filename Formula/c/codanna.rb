class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "066016968799eb41a359254c59036f2faaf8b1c3a9c136535c09ddf13cce0bda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17be69adc98e8ce0860df8ed39dece1ea171a2894945cebb4857f43f40356cfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee27bfaf4602734bc0401636ff957e62daa59706dc3c168199b0d52c109d6f42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5191ad778f9809f996c68623cc3f783cf127cdefc0218dc830a2734656ff67d"
    sha256 cellar: :any,                 arm64_linux:   "6f4bcbf7d881d74c5e6bfa77a262e7f5051507bfba96b2b5f984a4df794cedf3"
    sha256 cellar: :any,                 x86_64_linux:  "dbb358a41efd752c82b29b9df7314f5f7ab1ca0c5bd77c798f2b27c362cbb7de"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end