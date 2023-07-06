class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.7",
      revision: "c879f900c4e91cff51d7bd9b8529c6302659ba68"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b15c04207a042748e5c07099694d0b5895af133cb81e2797e4d3433424330b5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a84e7d9288e7903601077bde8a92654320c5bc6bffbb6ecb2c8faa06acb863bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0f60b6e2bcda8fac7d7b95c07de710ec40a8f1fd89a0e1fed9b67aead9ee723"
    sha256 cellar: :any_skip_relocation, ventura:        "79003b73b5b0ab4dfb6c6e6626cdafe59ad3e0c14662e556c6b68f31ea4a7a61"
    sha256 cellar: :any_skip_relocation, monterey:       "200d74cc2e4f14829f44245bc46eb6a78147f506553126b3908237653811b91b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdf90aaa8cc5ef9a140246b4b11b30f8d1799e98f259cf079c51f34ef6037121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56d7cbaf0ab5b674460ce652fe029818517fd25000e96856306b28dc2d7f28c3"
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "_output/local/bin/#{OS.kernel_name.downcase}/#{arch}/s2i"

    generate_completions_from_executable(bin/"s2i", "completion", shells: [:bash, :zsh], base_name: "s2i")
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end