class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.53.5.tar.gz"
  sha256 "e66b488b29666d1cb92b39107be5571d867de941f207faf1b69482aa3ded47fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c77bd01d885f67ca5ac4cbff82ab1fc54ca76b0e75d9b8e68857ceb77eaf3d19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acd4851a8592c70b9e338e70c90dee37292b88f4b1073d9b073ed2e68fcf4599"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41759b30fee4c8b6b8b640dc6ea3f4e19c4b3d451b5cb5e8e657c79c2651ad9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b521b4168e6b335450cef2adbdfd0136240d0aa3a400161a185e24765254c79"
    sha256 cellar: :any_skip_relocation, ventura:        "a84225435363686ec4b84b88da9d236e0a13a418136d717bbc8b56f00fb4832c"
    sha256 cellar: :any_skip_relocation, monterey:       "35c0e1fb20855d21ec0a203488297ffd07fc2e9b6fbeac9570a3e77f615f5b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ac38e5f522c6ba2a8f1b9c20b94dda089751b6e7145115e22c748e3f4bcb23b"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end