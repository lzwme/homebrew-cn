class Hcledit < Formula
  desc "Command-line editor for HCL"
  homepage "https:github.comminamijoyohcledit"
  url "https:github.comminamijoyohcleditarchiverefstagsv0.2.16.tar.gz"
  sha256 "fc7a91a11b0dcba039d34425f5acd4f786824a58c39e53aa6c553097287532bc"
  license "MIT"
  head "https:github.comminamijoyohcledit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2d194861571963e5e60773623c3a6f0b20c39b62f7484ad5cad1d41ddfe4857"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2d194861571963e5e60773623c3a6f0b20c39b62f7484ad5cad1d41ddfe4857"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2d194861571963e5e60773623c3a6f0b20c39b62f7484ad5cad1d41ddfe4857"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a201ba527e406a1b0d2005b736613294217ad2a6634a656a1dc99f192e7ebc4"
    sha256 cellar: :any_skip_relocation, ventura:       "2a201ba527e406a1b0d2005b736613294217ad2a6634a656a1dc99f192e7ebc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3d1694eb92ee46fcd13872c9a9124bfc33cb1f1b44bfd99b3f11c285152edf1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comminamijoyohcleditcmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hcledit version")

    (testpath"test.hcl").write <<~HCL
      resource "foo" "bar" {
        attr1 = "val1"
        nested {
          attr2 = "val2"
        }
      }
    HCL

    output = pipe_output("#{bin}hcledit attribute get resource.foo.bar.attr1",
                        (testpath"test.hcl").read, 0)
    assert_equal "\"val1\"", output.chomp
  end
end