class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "4b4208bdf1aeb91def3ba3a42236d21b98dd35b2a92769baadb76c3950399023"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "876566b3318ddcbf175c16aec074315f5f88a23bf8326af3a1def389cce734d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1937a87bdcf00be33c5b2bb56d65afdb054885c7f7e019cb3332e9e574633437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "246388a66c3b7f811a632ab24d0636df45195d542505f05d2e5ab8d74b4a5da4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c97b89ef0bde40d69170b45293e14839fe5b6bd1b62fefbe5a2757d7b4dd5e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31b0e1e5de04b6643730a242b9a644c4deb4fd1d444b6cabda94747b59cde3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66e70994dfa2f63b284c1e677aed21c6446f020e17d95105498874e6e01b6d54"
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

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end