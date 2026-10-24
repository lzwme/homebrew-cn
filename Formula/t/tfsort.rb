class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https://github.com/AlexNabokikh/tfsort"
  url "https://ghfast.top/https://github.com/AlexNabokikh/tfsort/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "689434eacb8a020a3194b8e897b0f34daca1aa4820a2cfd9bb0f8b558bdc4858"
  license "Apache-2.0"
  head "https://github.com/AlexNabokikh/tfsort.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf0f38384d1c8c1aa483d2077cf125a3931874e7870cc2c58f7418cb1e1b2e99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf0f38384d1c8c1aa483d2077cf125a3931874e7870cc2c58f7418cb1e1b2e99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf0f38384d1c8c1aa483d2077cf125a3931874e7870cc2c58f7418cb1e1b2e99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b54ad921476b49a3c389fa288d17d6ff7fbe67f133e0718b364df3d3cf63aabf"
    sha256 cellar: :any,                 x86_64_linux:      "19654bf787c357d974637d2a228a877d1a4da3b997f55e411f6ade75fe15ad62"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    # install testdata
    pkgshare.install "internal/hclsort/testdata"
  end

  test do
    cp_r pkgshare/"testdata/.", testpath

    assert_empty shell_output("#{bin}/tfsort invalid.tf 2>&1")

    system bin/"tfsort", "valid.tofu"
    assert_equal (testpath/"expected.tofu").read, (testpath/"valid.tofu").read
  end
end