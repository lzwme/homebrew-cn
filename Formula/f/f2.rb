class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https:github.comayoisaiahf2"
  url "https:github.comayoisaiahf2archiverefstagsv2.0.3.tar.gz"
  sha256 "164e1282ae1f2ea6a8af93c785d7bb214b09919ad8537b8fbab5b5bc8ee1a396"
  license "MIT"
  head "https:github.comayoisaiahf2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "102beebfbd41758b97daf1e7046d8f5447e3851f507a07b8fe113c81e96e80f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "102beebfbd41758b97daf1e7046d8f5447e3851f507a07b8fe113c81e96e80f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "102beebfbd41758b97daf1e7046d8f5447e3851f507a07b8fe113c81e96e80f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6a7dd847b9498a136b9680531cd4d99e1faaf320f30a2c51d8b8f31e1998d6f"
    sha256 cellar: :any_skip_relocation, ventura:       "c6a7dd847b9498a136b9680531cd4d99e1faaf320f30a2c51d8b8f31e1998d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c197664eb13a389ea69c122ea8dbe4aaeb426c7db9724400631f4aca9a1dd6a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, ".cmd..."
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_predicate testpath"test1-foo.bar", :exist?
    assert_predicate testpath"test2-foo.bar", :exist?
    refute_predicate testpath"test1-foo.foo", :exist?
    refute_predicate testpath"test2-foo.foo", :exist?
  end
end