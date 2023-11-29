class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.1.3.tar.gz"
  sha256 "4daabd9e1c91013d5b7617b5374a1dbc05b13e12c2f4efb896f500ef06437f6f"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "019c4a8a91655936b4ccaece5da2c9486bfe3d35e70d9a696cf3b02ee9c54306"
    sha256                               arm64_ventura:  "39da7681c2a4c3ec6c514aec44f7240fef16954ae0640d3d453b06d8ac172401"
    sha256                               arm64_monterey: "0c87037b79553dcaf3a64d11fe161960cb9f887845d0dca53ce8c3022a032422"
    sha256                               sonoma:         "fc5194dcd655455e9ef33874b818f2dd3243565ee85f5f3b0f11010b08167476"
    sha256                               ventura:        "37784a4fe8d61b5c1eae4d52b16e230d2263249fa8650c1e2353eacff0d75a99"
    sha256                               monterey:       "806a82fe69b99b38bfb1c6aa1d334fe9b0a214053460eaf703feca4b9d2146a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6843dc7da126214f72cfc181f911482295fc83259bd20f882a8a21a0150eb166"
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