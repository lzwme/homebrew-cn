class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.26.1.tar.gz"
  sha256 "5c52b1e50602a8caedfbe33b48ee56e1aa581993b82c518de6521a4ebf52e058"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfa29e901bdab048edc4239c20c4162398a97abf657691a423274faa15873edd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0355152cb96dd853c05552b7e082aedb6e673d2ba6e51c9da0edec7aa742c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcfe654898883b5a2528fe135a06f3d8f0d4353eacd6f7ff5a67a25489f3bcd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "afae49889fe15de1fc546e6ef2dc91d3dc7df3c98e43d41c1aa9bcaf4510f1af"
    sha256 cellar: :any,                 arm64_linux:   "4ac84f4fd7de4d021f7a73cfc0860e14b04de8b8412fd3f1819e129ef4ce67f5"
    sha256 cellar: :any,                 x86_64_linux:  "7778efc3a2cb1cab28e6cb782295ef2e39c77e56b2342139cf8549f3bc10c1b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end