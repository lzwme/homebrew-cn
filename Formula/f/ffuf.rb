class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://ghfast.top/https://github.com/ffuf/ffuf/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "cdb2e58259f380862850eba587f71a9dc1738fb5edc1ea60414fae30fd0ed4f2"
  license "MIT"
  head "https://github.com/ffuf/ffuf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56b545604136af7af0740ddbc0995318223424a878f1856ab22feb663c16d1e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b545604136af7af0740ddbc0995318223424a878f1856ab22feb663c16d1e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b545604136af7af0740ddbc0995318223424a878f1856ab22feb663c16d1e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac2ca04cdd67752dffaaec87edeab2ac983067312c49c8ee5a0835e64a8ff43"
    sha256 cellar: :any,                 x86_64_linux:  "e9b1535e39d9e8b4bd72c7ad189018b93d08c6c2f99e5f28b8c9869d6fc3c490"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end