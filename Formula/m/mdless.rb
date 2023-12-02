class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.1.6.tar.gz"
  sha256 "081865c75025dba88f1c1cb77b01161285ad0308aaf1de152e992d83d848bf96"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "45f7a5f09f1b489494dec147e6ea45715dc8f3da06e3159892e75efa7a90e1f6"
    sha256                               arm64_ventura:  "23262a3478bcdca92c6a41119f7058581bcb01b6b57f831094e4d5f6d677e0e0"
    sha256                               arm64_monterey: "64997aaaf62f61feb85293de6d37dfa938e179b6429d6316a5079ba20b1c5059"
    sha256                               sonoma:         "d07a67a26454cc33e557d3f963b760594d52e039f674f773a305f2d92c6c4e39"
    sha256                               ventura:        "73476210366815b81fc0b7a91ae684bd98aba902c8c5fd9d8e39a17d2f97a4d9"
    sha256                               monterey:       "62af149f5e4d9eeb7dd38d76e7778070935e4f81abb84fab61fb695f84ef680d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79e66217e623c338893186f22e7c6ec3a3d526fb0728d2387245f1a087c84f19"
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