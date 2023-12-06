class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.1.28.tar.gz"
  sha256 "816d774f2a4e1145091537bacd70f7bc1a3084944bc35b8bab0157386c334676"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7f634ef632a692c20d00930a276303ef4d20a681082eca622c4068cdd692328"
    sha256 cellar: :any,                 arm64_ventura:  "f8eea7dc55bd5efa8f9250ba5de4c5dfe89717262b85f3c8be383619d8123491"
    sha256 cellar: :any,                 arm64_monterey: "5fded8882df3b1fb7c6f11c4deeeedfeb28d299f840c5a0b379e76b4ad7fdab5"
    sha256 cellar: :any,                 sonoma:         "c4f594c79c275778f8ced9e0a91563bbcb6b14b565b4f85561e6152cf1ceb29a"
    sha256 cellar: :any,                 ventura:        "a8921fbd2b996e6cc44fa59cce9df19ee902b73302bac48e7f13adb0acc90b57"
    sha256 cellar: :any,                 monterey:       "519f73965c13571f4522e4c101e8218788ef6a7032b3ed1de080de19f4a87476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74e583889f984d1860d1a056994c34e5399a068d7efd0abdea8316c2880adb1f"
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