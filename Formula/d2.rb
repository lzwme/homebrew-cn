class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://ghproxy.com/https://github.com/terrastruct/d2/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "6bc67e1142b326762e65dfbaed94b4abca739f851cceff97f3086402175d527c"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d7fbcde54e91490d67da8c70d6120ab327db985f590308a1f01d0b74eafd526"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d7fbcde54e91490d67da8c70d6120ab327db985f590308a1f01d0b74eafd526"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d7fbcde54e91490d67da8c70d6120ab327db985f590308a1f01d0b74eafd526"
    sha256 cellar: :any_skip_relocation, ventura:        "4b3e94a3f9ef538f16f5591fb42bbcc8633877d4b74b33cff68049c45886e601"
    sha256 cellar: :any_skip_relocation, monterey:       "4b3e94a3f9ef538f16f5591fb42bbcc8633877d4b74b33cff68049c45886e601"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b3e94a3f9ef538f16f5591fb42bbcc8633877d4b74b33cff68049c45886e601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f15a13843275c7b81c15b9a2c9d3dd14e24b510a8b7a175dadbc6930f553cc9"
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