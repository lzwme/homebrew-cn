class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.1.11.tar.gz"
  sha256 "045069b86d412471c2183c2edbc3fc39fa1e536b84c8b0d924a6e6fedde629bd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5641457864ae5e41cc8f9cc73408153538fce056f23dda9eab259b016431e9d8"
    sha256 cellar: :any,                 arm64_ventura:  "6ba280a9c696a1bb87a726f80731af059b69b085ec58af2b88ad4ff75c68dbae"
    sha256 cellar: :any,                 arm64_monterey: "d9bd15ed81bcb556b1035f9bbde0a3ba7fa55c252981aaa6a6b04b9e38da2edf"
    sha256 cellar: :any,                 sonoma:         "2890938fe21cd85af3980098d5b0f8e907ae1c8c6937774ba5f30039c26b2fbf"
    sha256 cellar: :any,                 ventura:        "7d1b30e3836596e5e98ede69a19f1e4c85e2a54ea2ec3c891419ebc1a1f7657a"
    sha256 cellar: :any,                 monterey:       "4cf4b7b6ac491fbf97f2181e1fb4f95ff05ffbd0a80d134a68fbbda7278047ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea8bb5a6a88dc189a72b7b8cf2c4413af1b920ddead366775c78657fe5c2784"
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