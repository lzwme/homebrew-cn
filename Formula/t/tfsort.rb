class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https:github.comAlexNabokikhtfsort"
  url "https:github.comAlexNabokikhtfsortarchiverefstagsv0.4.0.tar.gz"
  sha256 "b1efeee957a11314aa6dfe2cb9f6ae3e8ee8bed18351daaf7348b13bbd818d4c"
  license "Apache-2.0"
  head "https:github.comAlexNabokikhtfsort.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59fe21c616a425dfa59d7a05b1cea91427d43b853641492804a8aba4d7ee202d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59fe21c616a425dfa59d7a05b1cea91427d43b853641492804a8aba4d7ee202d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59fe21c616a425dfa59d7a05b1cea91427d43b853641492804a8aba4d7ee202d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9e422de4603bda51a952451bd408bd01c2962be21e9a514ad10c5359946bcbd"
    sha256 cellar: :any_skip_relocation, ventura:       "c9e422de4603bda51a952451bd408bd01c2962be21e9a514ad10c5359946bcbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f719d148a0502350a980736ff85a2ad01fd2fb9fe07c79ad8e9f6a0a7101d8d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    # install testdata
    pkgshare.install "internalhclsorttestdata"
  end

  test do
    cp_r pkgshare"testdata.", testpath

    assert_empty shell_output("#{bin}tfsort invalid.tf 2>&1")

    system bin"tfsort", "valid.tofu"
    assert_equal (testpath"expected.tofu").read, (testpath"valid.tofu").read
  end
end