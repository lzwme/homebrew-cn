class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https:github.combazelbuildbuildtools"
  url "https:github.combazelbuildbuildtoolsarchiverefstagsv8.0.0.tar.gz"
  sha256 "1a9eaa51b2507eac7fe396811bc15dad4d15533acc61cc5b0d71004e1d0488cb"
  license "Apache-2.0"
  head "https:github.combazelbuildbuildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c166d8176c790d417d20cacde349c63e56e83cedd93ad646e8d22b709d2b4655"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c166d8176c790d417d20cacde349c63e56e83cedd93ad646e8d22b709d2b4655"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c166d8176c790d417d20cacde349c63e56e83cedd93ad646e8d22b709d2b4655"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c1a07d51287827cde0f6091cceb9b622c5932a1b58ce35c06f4175b7725d343"
    sha256 cellar: :any_skip_relocation, ventura:       "8c1a07d51287827cde0f6091cceb9b622c5932a1b58ce35c06f4175b7725d343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fbf02e6fcca5bb101ac8741be5f17487d44aef562e4c5c1cb35ce254bb63692"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".buildifier"
  end

  test do
    touch testpath"BUILD"
    system bin"buildifier", "-mode=check", "BUILD"
  end
end