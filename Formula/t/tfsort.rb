class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https:github.comAlexNabokikhtfsort"
  url "https:github.comAlexNabokikhtfsortarchiverefstagsv0.5.0.tar.gz"
  sha256 "318b025f4e0f4807df30b6f26271ae583bf7942b9829214927de7a1a4ec8ecc8"
  license "Apache-2.0"
  head "https:github.comAlexNabokikhtfsort.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dacad22dfae681a7814b738eb03b43d0d7dcab397aec089b593f7e31285e213f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dacad22dfae681a7814b738eb03b43d0d7dcab397aec089b593f7e31285e213f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dacad22dfae681a7814b738eb03b43d0d7dcab397aec089b593f7e31285e213f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8f12f4272fbfb70f455365eba3d949a87cf18101815b83f12ffdd8ccd54e505"
    sha256 cellar: :any_skip_relocation, ventura:       "c8f12f4272fbfb70f455365eba3d949a87cf18101815b83f12ffdd8ccd54e505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70224339c36fd9e74e0dd174231f8738a35a746d3cdf8553e25d61bc6f5ee645"
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