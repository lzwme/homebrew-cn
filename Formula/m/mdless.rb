class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.1.23.tar.gz"
  sha256 "b0a49434f90e44db904996d20370cfc88fed67d87e4e61b843ddb28307eb45f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd0dfe51a680233ab436f67d173bc540a0776f5b9dd0014ff84058dadb64355c"
    sha256 cellar: :any,                 arm64_ventura:  "80d195d434f56d3652b2a387b04748a62812e5493f403b8bd5765663ec5a14ab"
    sha256 cellar: :any,                 arm64_monterey: "8683e2ba2a5a1a778ce1abb86f3a542ed477245ab2bfa9694c3e0ac491360924"
    sha256 cellar: :any,                 sonoma:         "cf792b594857ab9a1434869a4077aabfb536eb92c81f64cd23f12422ad83d2ee"
    sha256 cellar: :any,                 ventura:        "5aee6d2b49f436123e0e91cc93257b18e9c59937ae9b9d1fdeb957f97a8926f4"
    sha256 cellar: :any,                 monterey:       "d524878093c44c1c8d268e0dab90a54765b45cb4ef886981964a9ba81c1991e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff52235c06083141c65208180495cf902e1a3aedb1848995fd63976c3ff9cce9"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    (testpath/"test.md").write <<~EOS
      # title first level
      ## title second level
    EOS
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end