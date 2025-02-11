class Jd < Formula
  desc "JSON diff and patch"
  homepage "https:github.comjosephburnettjd"
  url "https:github.comjosephburnettjdarchiverefstagsv2.0.1.tar.gz"
  sha256 "7867051f42cc27dd359c694e48c143cba544dec5071c99ae71e23263a2497fe4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fa4a95de36de37c007af7f9a0ef9071c59bb4b8cf380e8424e37c33c0015e17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fa4a95de36de37c007af7f9a0ef9071c59bb4b8cf380e8424e37c33c0015e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fa4a95de36de37c007af7f9a0ef9071c59bb4b8cf380e8424e37c33c0015e17"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bad7b517562b8ac64cf1be5adc4590df3471171abf226e7739c70760dddf008"
    sha256 cellar: :any_skip_relocation, ventura:       "0bad7b517562b8ac64cf1be5adc4590df3471171abf226e7739c70760dddf008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8afe08b6d15c4610251e9cce90b56988d2ac1a577a5d213c8f34e5a0bbf3a87"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"a.json").write('{"foo":"bar"}')
    (testpath"b.json").write('{"foo":"baz"}')
    (testpath"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    assert_equal expected, shell_output("#{bin}jd a.json b.json", 1)
    assert_empty shell_output("#{bin}jd b.json c.json")
  end
end