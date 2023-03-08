class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://ghproxy.com/https://github.com/terrastruct/d2/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "242b35112c04d370e01715b59fd8703e9ddb6a57e92e706250703ac328423c45"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "559d4bfebc38cfd300dcd0374836ff90580a3e577350a2f8bc2f26edb48494d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "559d4bfebc38cfd300dcd0374836ff90580a3e577350a2f8bc2f26edb48494d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "559d4bfebc38cfd300dcd0374836ff90580a3e577350a2f8bc2f26edb48494d5"
    sha256 cellar: :any_skip_relocation, ventura:        "a73d94ebba6f29439be0bed5d4797522959626ac17529b3fd43efd9b811865a2"
    sha256 cellar: :any_skip_relocation, monterey:       "a73d94ebba6f29439be0bed5d4797522959626ac17529b3fd43efd9b811865a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a73d94ebba6f29439be0bed5d4797522959626ac17529b3fd43efd9b811865a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f747c110ca0a250c662aded1978c3ea2e0494b1d1be3b5db791dcdf14870396"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end