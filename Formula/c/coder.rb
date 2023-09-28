class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "2b260271f7e721369d90c1b68a98d2272d8a469bd5766a82508f8d9600e5104a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72f6c9464bebf479dd6b85cf56480de44bde1e76c43415a33a11813401522907"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a7523d6315c4f1dd46fccc8ced12c529639ad23da0cbbf6f86db8c8b267b250"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94566104b58dde0b2fc9f9c92b76a46f1f522c0f876db5c03a67fa5c7dafb3bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d46cde76e3e054c8180bdbda9b89475b63573c05a2e612ce29389948d5a8e41"
    sha256 cellar: :any_skip_relocation, ventura:        "3045d711154650e7e81712b475a2646cba7063d05b2c8676f122b817643ca3e3"
    sha256 cellar: :any_skip_relocation, monterey:       "b36553ef93aa299eee39bb3e1c9e244cb29035c059500048fe154e31a2317c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d6ea506cd7c8d337f669bb65b7da2b8a69eaffdf405a226c3d7b4a7040866b1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end