class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghproxy.com/https://github.com/k1LoW/tbls/archive/refs/tags/v1.71.1.tar.gz"
  sha256 "dcc2cb25c2606f95813929d9788086cb9656f3c364a13daf86536742dc611c30"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91224bc9c890e0f28749a4cbdd2d8789346a23c5c778d6eb114416cb9402b7f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a32a945ff451fe706f5d86d516d0da13efbe11f5eae163d52bb82ae728844f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b31c60bf71d44a8bb32fa3359a1f1107ed752f791f7a4e7460463601c664f306"
    sha256 cellar: :any_skip_relocation, sonoma:         "6315e87f3866ba513951d412146eb1d12b92b4cf7a1b8fb951ac33dcf84d7ca3"
    sha256 cellar: :any_skip_relocation, ventura:        "e042127e42fea2251e42c4594a1861764f1168e994be161a92d09c7438e83b1a"
    sha256 cellar: :any_skip_relocation, monterey:       "06ea2ad2167e5a77e5d4db1e52905aaf93a8181714a3760c72a98d4be203d88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e6ae146a58376951485b51a0ffa94f189739fad0be4a064b9bdfde5a40a7933"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end