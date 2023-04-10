class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://ghproxy.com/https://github.com/terrastruct/d2/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b905a384b6fcd46da325d638d097545bb3795704fa5c3ef52cbf92fabc7b017d"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa6980eac7277991f19b62db965ad917db2f8bd782e14a05d0abf139f53622ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa6980eac7277991f19b62db965ad917db2f8bd782e14a05d0abf139f53622ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa6980eac7277991f19b62db965ad917db2f8bd782e14a05d0abf139f53622ee"
    sha256 cellar: :any_skip_relocation, ventura:        "aaeb30f27684f86c035ff28a79447b009eaff3189130bb51232f2eed4eba5f7d"
    sha256 cellar: :any_skip_relocation, monterey:       "aaeb30f27684f86c035ff28a79447b009eaff3189130bb51232f2eed4eba5f7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaeb30f27684f86c035ff28a79447b009eaff3189130bb51232f2eed4eba5f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8376a6a43a0be965cb53b7c093afae42462d965c96dad5bf2818803495809872"
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