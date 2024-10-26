class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.79.0.tar.gz"
  sha256 "32d01d26bd4ffedef397ffe30588d43961a134bcae87ff97cfe9a5973be68f84"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a4be8cd03675824a26910747253624b5d7bc4f90e471caf609f4cd58f3e76c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32c8f237f7ce7d16a8578c67255a266fdbf7ce5fc083b965e049bdf9b078b0bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f762fd522eb3ee43aec17002b50c5bc11106b57d4884194f8e52d7f8da81fab"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef4e4b6eb73ca4ebc67c61edb07c9b45eb2409438c7031d53b824b6281e1c45b"
    sha256 cellar: :any_skip_relocation, ventura:       "b64b33f97619fee9205c3f36a4cdb35e27bcee55a4e25beeed62da3bc30527b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf3c27af1d045414f9729fbf7e021766d3829929d5797dda2c8a36e8a0e6b482"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end