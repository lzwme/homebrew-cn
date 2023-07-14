class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://ghproxy.com/https://github.com/github/cmark-gfm/archive/0.29.0.gfm.12.tar.gz"
  version "0.29.0.gfm.12"
  sha256 "335289c48ece17eab6d6b0f3eb68df2464f6c5d7d228e014f7472e6e4737100f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "42548a3f26f1bbe13cc26c72e77c24ccee4b2e1740c60cec440585072800535d"
    sha256 cellar: :any,                 arm64_monterey: "9667ad608b3bc02c66849150d442d96ae1b87e2ffae1eddf27d5a0f90e18df91"
    sha256 cellar: :any,                 arm64_big_sur:  "4c9fee2234dc36d09f9d3d8d004d62b91a851b734122a36f7efac36edf34aac4"
    sha256 cellar: :any,                 ventura:        "cec76ffbd87e254054abc430e8cead8c9e866f07dfb99de32f48faa039ec1e76"
    sha256 cellar: :any,                 monterey:       "3e70211a46390f6c939097dbd9e420aa59b1e3ff16c20dd16821299bb0c8cdd8"
    sha256 cellar: :any,                 big_sur:        "42f9ab0e26897d6e5b6b1c37bb338b1ddc09fb57dd29a668152bef4fbe16fd15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "661b7eb311a34455214368dc199d6ff2d6be0877a65bebe12ce3a936fd9a651a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end