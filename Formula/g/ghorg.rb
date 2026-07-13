class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://ghfast.top/https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.13.tar.gz"
  sha256 "4f8dd72d1bb0a8f96489c9232c30be50f9eb1102b23ea3482856a485114d3496"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e48fd75396d6fb82d3f1987cd61b318f21b506e36d073467087aa1e364230f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e48fd75396d6fb82d3f1987cd61b318f21b506e36d073467087aa1e364230f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e48fd75396d6fb82d3f1987cd61b318f21b506e36d073467087aa1e364230f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e84118e0a6c2e361931e83af6332ea3a3d0add166383a234e78bd9f4ff63f4cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b400fc42c5f8f0af0efcde0c7fe85d0f1582f49915cee72b96f29edf979cc611"
    sha256 cellar: :any,                 x86_64_linux:  "99fc385b818b683dcd218d7f6691d3df21b38d52fcbac107f0fcf2db7609e772"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end