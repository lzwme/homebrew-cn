class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.0.18.tar.gz"
  sha256 "c8e7a4cf5a1d2a3cbdec95a0b137bff452b4cb0f4bb5b6010d89f7588faa4dd7"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "0b5ba7a340cfb92425b66ff99f9f2f48dfd3bf54b68ea339c7150860d7b38b3b"
    sha256                               arm64_ventura:  "aa8ac761d6b650b9c9d4a3194c5364a20b45bf397f9f09b66e3af6d53e4c14eb"
    sha256                               arm64_monterey: "74b8d9132f1f103a8efdd505d9540a8568df79f615b104a158373bafa9fee288"
    sha256                               sonoma:         "6c0f8a256bd8056517518eb7246ee199c2884bb99d70ca59559e9172a8c74bc2"
    sha256                               ventura:        "ea4179fb15ab9b3d7f167ab5ec6cfa7b21570628a4ca7d787c0626a2534aa690"
    sha256                               monterey:       "80dcc2517fec3bc6c1ed5bd4681f3977d10f00b7f16c4c8ed50026f4cf2bc3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ec4a7c89cd87d4e6a10209506adad134869c2e74a67bd494604fa74ba60faf6"
  end

  uses_from_macos "ruby"

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