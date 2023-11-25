class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.0.15.tar.gz"
  sha256 "e0820114811a17c3da76579d1c2860d0387dd1f9e667c2275bce554d9a3ad4d2"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "d7e429ec490918e836c7cf8c1043686c83acf1b8d68226c6282a5b004e1e0174"
    sha256                               arm64_ventura:  "6bf299486e721e97ebc6c2373b06c81c0407bf9628639077df827542591f2df3"
    sha256                               arm64_monterey: "9f95c9760739cf9435731209f98131d0857b2ff7158bb8cf38887341bedf90ae"
    sha256                               sonoma:         "3f65835344ef0814b2bdf0efd4e5c3fdbdd61e8a8ed0d3b0224762a7ec48d1ce"
    sha256                               ventura:        "749361b68d4522dfd76ec5958e8a2e14dbe7bd36c22e37c547a2996a8f39455c"
    sha256                               monterey:       "c29da2c2ae921f79bc0a02e52488bc4c3deeb5c5b8829fc22db80814d0d5e0d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ef109c49d1a711a44f04d212a9170e4f3c00c7aa646cf09e7c8479116d1b907"
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