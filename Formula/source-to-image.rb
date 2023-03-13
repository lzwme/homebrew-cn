class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.4",
      revision: "c6c9fedfe04013db9f7ef064d1b6a3583566be04"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea397cd56ebbe2b70c290701b1e9457ad2370275aaa3d6104363e36c4219d75e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2144d6cdff51f947202e2ad917504e4a465098e09a552d8888302b1de5175a4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b45d3ff7ae062416b87b723011209b98ba69a131db4711f8dd4ca282acf0440"
    sha256 cellar: :any_skip_relocation, ventura:        "0db3396b1e400d067163599c9052b1c5651f5daf52f2da7a6f51ec4bd9ff6063"
    sha256 cellar: :any_skip_relocation, monterey:       "f6c155f32b3cdba9bbb435cc4cb8f1e48e0f03636776cbf36d45b8743ad73e66"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fe3025755aba21b9c8f4aa653ed610f04912e0af44d5012145594d0a5d97ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67168282786958cabd1c93ec888ef155d45aab94f77323ff90aca663d9897bfb"
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