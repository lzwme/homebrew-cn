class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.8.0.tar.gz"
  sha256 "d0935eca6b03b0c037e6f0c9c4542365854d6ef9304810388c317beff15acdaa"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b12c54dcfa9948cd7b81996416568cc554f8ca1c5816736adaf3cd301f3a6445"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f799d51a01480186260e80700979228917fbfacac6018f2d527a22f410c5c81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d0cb070427525d0c69efd3ae34c099a02261675c195ed0ff9861285d5c1638"
    sha256 cellar: :any_skip_relocation, sonoma:         "32014b8c18239bb6817539ee0c2c1b74abd1e5e752c43dfc50997b361fce5b89"
    sha256 cellar: :any_skip_relocation, ventura:        "ac3ca83cd2de7d33cfd10ef526339ebe6085d1638d0b7d230c7a63fb98ae8b35"
    sha256 cellar: :any_skip_relocation, monterey:       "05759d87138a7782cb3a3c6358c798cd5eedde18d75b789d2fb72a07f582b4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6052e51774700b30f135442623c06ce52eec763237f1c302926254683653bda"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end