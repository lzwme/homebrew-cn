class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.21.1",
      revision: "407d6454a6a9e0130f230cac2614746509561eb7"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b55336d721ee820fe336cca2a25622654413c807b9f2e661d922a1e1c3d00b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806e12f25f97f7af2f2c066e63c0462c3c8b7fc6628eb93e637cf87285b139d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca90f3ed08b656ab668ada49dc8b62c66efcd22e37d2594a16a29c51c0581de7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02fce553f62c7c4dce8f5b8594a831fd02984cd70970d4d10e28795abb38ae12"
    sha256 cellar: :any,                 x86_64_linux:  "82ebab105b49ad56ca1f9c375bbccb0017476434df47e98d04e5462bebdc1cdf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end