class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https:ryelang.org"
  url "https:github.comrefaktorryearchiverefstagsv0.0.20.tar.gz"
  sha256 "872d67062dfde0c815d59236ac98c53579d5dc1f9ecf2c6720819b19cfb59e6d"
  license "Apache-2.0"
  head "https:github.comrefaktorrye.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4d80008a5ca277362d27efbef40ac713f2c78ae6f277e4d5e15c23fb41e8380"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c8c369ee8f55e88cef30620212f3f907a30c9334df230f67ba0034fb8739c0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9d85868d9f76ebc283525aa2340057ad5efda2697735b83c5732b6fe4be4f69"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8b6b506a5bd4034c262857b8ceb728868c6135dcab05ae825f1fa42ef3693c9"
    sha256 cellar: :any_skip_relocation, ventura:        "26c3147e178203d75087e6f068d932b652c10abe8271d2c0b45b655a00c0a904"
    sha256 cellar: :any_skip_relocation, monterey:       "9b82d950eea3da7b53b20c0f10dcf2d7288d1fbf9522ae3d9a4200057ece7994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f3f90a2db216aad50f4c66636c7b3091c21875122fc5a583ded9cf7f953e60"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath"hello.rye", :exist?
    output = shell_output("#{bin}ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end