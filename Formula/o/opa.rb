class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "38b73b62a9198aa7f1818bfdee16153da2cfa6c0cef1bfebebc458a263ae6a9c"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c680823c2fbee03841c7cd5087b335e06278be13460ca62a1174a580c4b84d40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c86baca4da64955056db3ac350a5b31ff8688b3c33061ac8e4836bd338d7c2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1771fe21c7baf94bbf9b99843656fc3c224e8afd8c1646863093cd7607e1aa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "deb7907dbc43580e3eec3c75d51b13a20b5de34b2b8158f08111db3ea143aa27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eedb99a86b976ec6174a30e50ec76b87892d906bc2406a2b82a86baeca66963"
    sha256 cellar: :any,                 x86_64_linux:  "641212860562633f0896c33c50c701023d2b778c6eb1bfa9b5a19eb5c4676dd4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end