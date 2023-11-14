class Tfproviderlint < Formula
  desc "Terraform Provider Lint Tool"
  homepage "https://github.com/bflad/tfproviderlint"
  url "https://ghproxy.com/https://github.com/bflad/tfproviderlint/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "60427ce6952106ba6c321555352645f051781ff55fe876b591e5dd2454852692"
  license "MPL-2.0"
  head "https://github.com/bflad/tfproviderlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9780b7215ac0cb5cb77729c5abec0a470222de4341b60cbeb60f578d7efa6767"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9780b7215ac0cb5cb77729c5abec0a470222de4341b60cbeb60f578d7efa6767"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9780b7215ac0cb5cb77729c5abec0a470222de4341b60cbeb60f578d7efa6767"
    sha256 cellar: :any_skip_relocation, sonoma:         "32c205b8bff8ecc8ecd59818a5ad3f5e1280b25b9046747a7149b9cd9c8b17af"
    sha256 cellar: :any_skip_relocation, ventura:        "32c205b8bff8ecc8ecd59818a5ad3f5e1280b25b9046747a7149b9cd9c8b17af"
    sha256 cellar: :any_skip_relocation, monterey:       "32c205b8bff8ecc8ecd59818a5ad3f5e1280b25b9046747a7149b9cd9c8b17af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d5103190a14b75826496cbe28614f49619a25d8f8492b4a1804e48e6c22bfca"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.com/bflad/tfproviderlint/version.Version=#{version}
    ]

    ldflags << if build.head?
      "-X github.com/bflad/tfproviderlint/version.VersionPrerelease=dev"
    else
      "-X github.com/bflad/tfproviderlint/version.VersionPrerelease="
    end

    output = libexec/"bin/tfproviderlint"
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: output), "./cmd/tfproviderlint"
    (bin/"tfproviderlint").write_env_script(output, PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
  end

  test do
    resource "homebrew-test_resource" do
      url "https://ghproxy.com/https://github.com/russellcardullo/terraform-provider-pingdom/archive/refs/tags/v1.1.3.tar.gz"
      sha256 "3834575fd06123846245eeeeac1e815f5e949f04fa08b65c67985b27d6174106"
    end

    testpath.install resource("homebrew-test_resource")
    assert_match "S006: schema of TypeMap should include Elem",
      shell_output(bin/"tfproviderlint -fix #{testpath}/... 2>&1", 3)

    assert_match version.to_s, shell_output(bin/"tfproviderlint --version")
  end
end