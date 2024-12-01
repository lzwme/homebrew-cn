class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https:ryelang.org"
  url "https:github.comrefaktorryearchiverefstagsv0.0.32.tar.gz"
  sha256 "2de813bdd9719344cf4d75c434111b575aa3c31f3447d43a52a4fabf4f5be562"
  license "Apache-2.0"
  head "https:github.comrefaktorrye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "958213dd4a5a8293c50859133cb3810634229d29f74feda27da299306202d1b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b94ff1511ca4f59568b67e49a1c1d8ebc068a3897dd4842f6c80930e99b84ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eba2de9c55a15aa17001cddef0bf482d1c5c36066d982433ab46ce6da9fe2edd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8e98a260b7a369b5b27122b6d8a81099390cadd4e1237ae69e02ee3d2be3432"
    sha256 cellar: :any_skip_relocation, ventura:       "19683968fe91c6a404aaa29d95c4709170e6312143b23b4519dbf133b6ffe1a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a07b288ca72a5ed2d218833d84440b1cbf1cbfb0f3cabeccf91230da07b1611d"
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