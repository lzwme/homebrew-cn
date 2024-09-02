class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https:github.comawslabsdiagram-as-code"
  url "https:github.comawslabsdiagram-as-codearchiverefstagsv0.21.4.tar.gz"
  sha256 "5ad21ca13d25536297dd807c6c9ea0d3fbc9f2a0a13895406ccd9958034b671f"
  license "Apache-2.0"
  head "https:github.comawslabsdiagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5b90bbc66843e5736a378bed695afe73b91609747723ad94d9a79d029e16495"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5b90bbc66843e5736a378bed695afe73b91609747723ad94d9a79d029e16495"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5b90bbc66843e5736a378bed695afe73b91609747723ad94d9a79d029e16495"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd5510caded9eb26eb4dd173fbcece738ea5c9befe7d0d546f5ceef6ceda9cc6"
    sha256 cellar: :any_skip_relocation, ventura:        "cd5510caded9eb26eb4dd173fbcece738ea5c9befe7d0d546f5ceef6ceda9cc6"
    sha256 cellar: :any_skip_relocation, monterey:       "cd5510caded9eb26eb4dd173fbcece738ea5c9befe7d0d546f5ceef6ceda9cc6"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https:github.comawslabsdiagram-as-codeissues12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdawsdac"
  end

  test do
    (testpath"test.yaml").write <<~EOS
      Diagram:
        Resources:
          Canvas:
            Type: AWS::Diagram::Canvas
    EOS
    assert_equal "[Completed] AWS infrastructure diagram generated: output.png",
      shell_output("#{bin}awsdac test.yaml").strip
  end
end