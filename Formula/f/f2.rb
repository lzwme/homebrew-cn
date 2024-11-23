class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https:github.comayoisaiahf2"
  url "https:github.comayoisaiahf2archiverefstagsv2.0.2.tar.gz"
  sha256 "c5f95ae41f3c7966e39aa8ba4e9fc6a45cea1a451788c20e8df9be7981c7614b"
  license "MIT"
  head "https:github.comayoisaiahf2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f4803de329ac29d29612f465c46e67bdf4fd401a217867f9c7f74311be26141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f4803de329ac29d29612f465c46e67bdf4fd401a217867f9c7f74311be26141"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f4803de329ac29d29612f465c46e67bdf4fd401a217867f9c7f74311be26141"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b219b3d34f73b3f08014c229499a48b685655c6dd84e8d6351819c361e9286f"
    sha256 cellar: :any_skip_relocation, ventura:       "6b219b3d34f73b3f08014c229499a48b685655c6dd84e8d6351819c361e9286f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78c97e892c09a36af4b11ae2153058b75a429d87befb1c91a2197bb89da7e063"
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