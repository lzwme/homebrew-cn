class TfstateLookup < Formula
  desc "Lookup resource attributes in tfstate"
  homepage "https://github.com/fujiwara/tfstate-lookup"
  url "https://ghfast.top/https://github.com/fujiwara/tfstate-lookup/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "0caf56d6f9b7c7ef489304c865c22405216273d91e97dcda4ae2c140b3d8b439"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a42f45c5a165f998239542d6d2b962c7be9eb2902363e0e6e8afa4410814071"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a42f45c5a165f998239542d6d2b962c7be9eb2902363e0e6e8afa4410814071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a42f45c5a165f998239542d6d2b962c7be9eb2902363e0e6e8afa4410814071"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ede00e3dc2728f2b97c329e82e39e0090391c2a925321f0a4439672e2f3eef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13d5d99c0aab4d8ca89157408b1209103784da6d8bc46b098625b6a6832ebc92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1413282febebd73ffbccddddbe2ebec9a6f7dfbe0f4f015c0184e092c3c2bbd3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tfstate-lookup"
  end

  test do
    (testpath/"terraform.tfstate").write <<~EOS
      {
        "version": 4,
        "terraform_version": "1.7.2",
        "resources": []
      }
    EOS

    output = shell_output("#{bin}/tfstate-lookup -dump")
    assert_match "{}", output
  end
end