class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.0.7.tar.gz"
  sha256 "4baf22a4ed0805519c86b324f31c8ddfa9829a55d127209eb7ff8e3ecaa5ef87"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "e2a824f608fd8a4236fbcbcf5e1118bb3843f29fdf5eb8e00b4d0c57064d9e83"
    sha256                               arm64_ventura:  "d714e428a38bfdcc7792950bc08a8a41254d0a8df3bb829254054b6cd504c96d"
    sha256                               arm64_monterey: "3c1e03d34f724082f70dc848b575b17570f139a0c0426965ea73c1286244e56b"
    sha256                               sonoma:         "dc7f3d238a90a80e8f768d370895cfa26eee303ed308124748a638fea84f47e7"
    sha256                               ventura:        "aabb826f7d90a27ddb3bee2fe2061fce0b79ae45df9596c6765291efb2109ee5"
    sha256                               monterey:       "eb958694e17b8097e2bd4eb326b0c3ac3f68b17c1ccce68822d7a9bba321086c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18c0f49b760716177c014abe3e9bf0afcba6ba1cfd4fa7fe4f372c9e2221c9f6"
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