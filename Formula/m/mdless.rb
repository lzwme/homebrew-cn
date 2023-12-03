class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.1.8.tar.gz"
  sha256 "3775889b443d9f2101474f3c579331b99dfee22a6db251b61791a1867ec6a154"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "ff2462382241b46a44ebe70f00aa3ffc09c45b75deb77e4ab8d3373ca61efd75"
    sha256                               arm64_ventura:  "378a2d6d1a2c78abd0bcb96257768abe7b4406782178d5407709a6989a6548da"
    sha256                               arm64_monterey: "f8f95a8c2b029020ee33f24dc2a73ca09635701de9bf47291b78fcf8d7eb1fae"
    sha256                               sonoma:         "fa354650093fe261e338a8ff2263e570a11c0bb8c5bfa2eece965fd3dcbb7ff5"
    sha256                               ventura:        "fd19c0e9778c8f860c80407198c9d2b218dfb214f9026816b9c54e5fb6615c24"
    sha256                               monterey:       "8b562119609d9cbbeb5dedfcd17859423cbdd2250a2d5811aa475d73ef9a61ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ff903fb422da7215223ba1eec69ce32671e10e463fa0f07db84c62ef80c928c"
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