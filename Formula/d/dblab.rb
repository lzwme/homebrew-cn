class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "fbd62c9a173fdbe8909a636f0c1a7ca3d4ec3617accccd4866e9955618b49e80"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2232e75ad9321a2710e817ab9f42000a33ccbc24aa58a9e54795e3612effb4bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2232e75ad9321a2710e817ab9f42000a33ccbc24aa58a9e54795e3612effb4bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2232e75ad9321a2710e817ab9f42000a33ccbc24aa58a9e54795e3612effb4bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "33a1d7131de40b88fb774d15c959c3c1718214ca7b35f76b86924b7f1c772737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c45e09628860b75b3270223862afc43fa9c17cb7a1d76b8d18ee7c466b2af5be"
    sha256 cellar: :any,                 x86_64_linux:  "89c08c68bd623b3cab9bf7d370d6b63d75822aa0bcce8cbbc9640a74fb794dae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end