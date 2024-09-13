class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https:jbang.dev"
  url "https:github.comjbangdevjbangreleasesdownloadv0.118.0jbang-0.118.0.zip"
  sha256 "689f7d974e6b6bfd7b29480ce5c87bcf6a3124fab33c15248566d6360835bee3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "44c365854523952aeba9d89d6b98f5ed3164e53c3af67a783f4bf379909d73d3"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}binjbang", ^abs_jbang_dir=.*, "abs_jbang_dir=#{libexec}bin"
    bin.install_symlink libexec"binjbang"
  end

  test do
    system bin"jbang", "init", "--template=cli", testpath"hello.java"
    assert_match "hello made with jbang", (testpath"hello.java").read
    assert_match version.to_s, shell_output("#{bin}jbang --version 2>&1")
  end
end