class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.9.1.tar.gz"
  sha256 "0feace7cfd1fe286468109ece83f7bb6823514c6168ca7ed0c211bdc1e5b9ba3"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cd757210e33b2e7dbd0278f345cc304fbb530850948ab6ed02d98f4b4b349f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c6e6393c0b9e8008ab706317070472c955978eefe97ddfb032d11fadb60bc1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cecc8d4846696eda949a9957fd234d6561c7a5a321386b6c111cfb16bae99782"
    sha256 cellar: :any_skip_relocation, sonoma:         "a880ef167904e8d7a97843c79c829890027b95af1b91df985d84e68271b295eb"
    sha256 cellar: :any_skip_relocation, ventura:        "cfcae6ea57b6a953d81b0c08192204d62f195dab661f0225b9d60d0152822b32"
    sha256 cellar: :any_skip_relocation, monterey:       "642c2bd2e64bb763f4c42c4e8a2833c44923d929b39230be6644251414e732b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c3b77be6049e2494434a9b6ba38dd15437486a1aed6b0b0454bcc8adb95ab81"
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